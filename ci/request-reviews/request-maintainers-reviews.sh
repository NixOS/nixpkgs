#!/usr/bin/env bash

# Requests maintainer reviews for a PR

set -euo pipefail
SCRIPT_DIR=$(dirname "$0")

if (( $# < 5 )); then
    echo >&2 "Usage: $0 ORG_ID GITHUB_REPO PR_NUMBER AUTHOR COMPARISON_PATH"
    exit 1
fi
orgId=$1
baseRepo=$2
prNumber=$3
prAuthor=$4
comparisonPath=$5

org="${baseRepo%/*}"

# maintainers.json/teams.json contains GitHub IDs. Look up handles to request reviews from.
# There appears to be no API to request reviews based on IDs
{
  jq -r 'keys[]' "$comparisonPath"/maintainers.json \
    | while read -r id; do
      if login=$(gh api /user/"$id" --jq .login); then
        echo "$login"
      else
        echo >&2 "Skipping user with id $id: $login"
      fi
    done
  jq -r 'keys[]' "$comparisonPath"/teams.json \
    | while read -r id; do
      if slug=$(gh api /organizations/"$orgId"/team/"$id" --jq .slug); then
        echo "$org/$slug"
      else
        echo >&2 "Skipping team with id $id: $slug"
      fi
    done
} | "$SCRIPT_DIR"/request-reviewers.sh "$baseRepo" "$prNumber" "$prAuthor"
