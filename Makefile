export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION=us-east-1
SHELL := /bin/bash

## Show this help
usage:
		@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

## Install dependencies
install:
		@which localstack || pip install localstack
		@which awslocal || pip install awscli-local
		@which cdklocal || npm install -g aws-cdk-local aws-cdk

## Deploy the infrastructure
build:
		npm install && cd demos/rds-query-fn-code && npm install

## Bootstap the CDK sample
bootstrap:
		cdklocal bootstrap

## Deploy the CDK sample
deploy:
		cdklocal deploy --require-approval never

## Start LocalStack in detached mode
start:
		RDS_MYSQL_DOCKER=1 localstack start -d

## Stop the Running LocalStack container
stop:
		@echo
		localstack stop

## Make sure the LocalStack container is up
ready:
		@echo Waiting on the LocalStack container...
		@localstack wait -t 30 && echo LocalStack is ready to use! || (echo Gave up waiting on LocalStack, exiting. && exit 1)

## Save the logs in a separate file, since the LS container will only contain the logs of the last sample run.
logs:
		@localstack logs > logs.txt

.PHONY: usage install bootstrap build deploy deploy start stop ready logs