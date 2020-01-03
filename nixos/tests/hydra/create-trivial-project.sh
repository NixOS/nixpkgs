#!/usr/bin/env bash
#
# This script creates a project, a jobset with an input of type local
# path. This local path is a directory that contains a Nix expression
# to define a job.
# The EXPR-PATH environment variable must be set with the local path.

set -e

URL=http://localhost:3000
USERNAME="admin"
PASSWORD="admin"
PROJECT_NAME="trivial"
JOBSET_NAME="trivial"
EXPR_PATH=${EXPR_PATH:-}

if [ -z $EXPR_PATH ]; then
   echo "Environment variable EXPR_PATH must be set"
   exit 1
fi

mycurl() {
  curl --referer $URL -H "Accept: application/json" -H "Content-Type: application/json" $@
}

cat >data.json <<EOF
{ "username": "$USERNAME", "password": "$PASSWORD" }
EOF
mycurl -X POST -d '@data.json' $URL/login -c hydra-cookie.txt

cat >data.json <<EOF
{
  "displayname":"Trivial",
  "enabled":"1",
  "visible":"1"
}
EOF
mycurl --silent -X PUT $URL/project/$PROJECT_NAME -d @data.json -b hydra-cookie.txt

cat >data.json <<EOF
{
  "description": "Trivial",
  "checkinterval": "60",
  "enabled": "1",
  "visible": "1",
  "keepnr": "1",
  "enableemail": true,
  "emailoverride": "hydra@localhost",
  "nixexprinput": "trivial",
  "nixexprpath": "trivial.nix",
  "inputs": {
    "trivial": {
      "value": "$EXPR_PATH",
      "type": "path"
    }
  }
}
EOF
mycurl --silent -X PUT $URL/jobset/$PROJECT_NAME/$JOBSET_NAME -d @data.json -b hydra-cookie.txt
