#!/usr/bin/env bash

set -euo pipefail

ORG=$1
REPO=$2

# Takes a list of teams as JSON input, returns
processTeams() {
  jq -c '.[]' | while read -r team; do
    slug=$(jq -r .slug <<< "$team")
    echo >&2 "Processing team $slug"
    jq <<< "$team" \
      --slurpfile members <(gh api --paginate /orgs/"$ORG"/teams/"$slug"/members --jq '.[]') \
      --slurpfile maintainers <(gh api --method=GET --paginate /orgs/"$ORG"/teams/"$slug"/members -f role=maintainer --jq '.[]') \
      '{
        key: .slug,
        value: (pick(.name, .id, .description, .permission) + {
          parent: (if .parent != null then .parent.slug else null end),
          members: ($members | map({ key: .login, value: .id }) | from_entries),
          maintainers: ($maintainers | map({ key: .login, value: .id }) | from_entries),
        })
      }'
    gh api --paginate /orgs/"$ORG"/teams/"$slug"/teams | processTeams
  done
}

gh api --paginate /repos/"$ORG"/"$REPO"/teams | processTeams | jq --slurp from_entries --sort-keys
