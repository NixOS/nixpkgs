#!/usr/bin/env bash

# Get the code owners of the files changed by a PR,
# suitable to be consumed by the API endpoint to request reviews:
# https://docs.github.com/en/rest/pulls/review-requests?apiVersion=2022-11-28#request-reviewers-for-a-pull-request

set -euo pipefail

log() {
    echo "$@" >&2
}

if (( "$#" < 5 )); then
    log "Usage: $0 GIT_REPO BASE_REF HEAD_REF OWNERS_FILE PR_AUTHOR"
    exit 1
fi

gitRepo=$1
baseRef=$2
headRef=$3
ownersFile=$4
prAuthor=$5

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' exit

git -C "$gitRepo" diff --name-only --merge-base "$baseRef" "$headRef" > "$tmp/touched-files"
readarray -t touchedFiles < "$tmp/touched-files"
log "This PR touches ${#touchedFiles[@]} files"

# Get the owners file from the base, because we don't want to allow PRs to
# remove code owners to avoid pinging them
git -C "$gitRepo" show "$baseRef":"$ownersFile" > "$tmp"/codeowners

# Associative arrays with the team/user as the key for easy deduplication
declare -A teams users

for file in "${touchedFiles[@]}"; do
    result=$(codeowners --file "$tmp"/codeowners "$file")

    read -r file owners <<< "$result"
    if [[ "$owners" == "(unowned)" ]]; then
        log "File $file is unowned"
        continue
    fi
    log "File $file is owned by $owners"

    # Split up multiple owners, separated by arbitrary amounts of spaces
    IFS=" " read -r -a entries <<< "$owners"

    for entry in "${entries[@]}"; do
        # GitHub technically also supports Emails as code owners,
        # but we can't easily support that, so let's not
        if [[ ! "$entry" =~ @(.*) ]]; then
            warn -e "\e[33mCodeowner \"$entry\" for file $file is not valid: Must start with \"@\"\e[0m" >&2
            # Don't fail, because the PR for which this script runs can't fix it,
            # it has to be fixed in the base branch
            continue
        fi
        # The first regex match is everything after the @
        entry=${BASH_REMATCH[1]}
        if [[ "$entry" =~ .*/(.*) ]]; then
            # Teams look like $org/$team, where we only need $team for the API
            # call to request reviews from teams
            teams[${BASH_REMATCH[1]}]=
        else
            # Everything else is a user
            users[$entry]=
        fi
    done

done

# Cannot request a review from the author
if [[ -v users[$prAuthor] ]]; then
    log "One or more files are owned by the PR author, ignoring"
    unset 'users[$prAuthor]'
fi

# Turn it into a JSON for the GitHub API call to request PR reviewers
jq -n \
    --arg users "${!users[*]}" \
    --arg teams "${!teams[*]}" \
    '{
      reviewers: $users | split(" "),
      team_reviewers: $teams | split(" ")
    }'
