#!/usr/bin/env bash

# Process reviewers for a PR, reading line-separated usernames on stdin,
# returning a JSON suitable to be consumed by the API endpoint to request reviews:
# https://docs.github.com/en/rest/pulls/review-requests?apiVersion=2022-11-28#request-reviewers-for-a-pull-request

set -euo pipefail

log() {
    echo "$@" >&2
}

if (( "$#" < 3 )); then
    log "Usage: $0 BASE_REPO PR_NUMBER PR_AUTHOR"
    exit 1
fi

baseRepo=$1
prNumber=$2
prAuthor=$3

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' exit

declare -A users=()
while read -r handle && [[ -n "$handle" ]]; do
    users[$handle]=
done

# Cannot request a review from the author
if [[ -v users[${prAuthor,,}] ]]; then
    log "One or more files are owned by the PR author, ignoring"
    unset 'users[${prAuthor,,}]'
fi

gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "/repos/$baseRepo/pulls/$prNumber/reviews" \
    --jq '.[].user.login' > "$tmp/already-reviewed-by"

# And we don't want to rerequest reviews from people who already reviewed
while read -r user; do
    if [[ -v users[${user,,}] ]]; then
        log "User $user is a code owner but has already left a review, ignoring"
        unset 'users[${user,,}]'
    fi
done < "$tmp/already-reviewed-by"

for user in "${!users[@]}"; do
    if ! gh api \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "/repos/$baseRepo/collaborators/$user" >&2; then
        log "User $user is not a repository collaborator, probably missed the automated invite to the maintainers team (see <https://github.com/NixOS/nixpkgs/issues/234293>), ignoring"
        unset 'users[$user]'
    fi
done

# Turn it into a JSON for the GitHub API call to request PR reviewers
jq -n \
    --arg users "${!users[*]}" \
    '{
      reviewers: $users | split(" "),
    }'
