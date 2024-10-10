#!/usr/bin/env bash
# This checks for mergeability of a pull request as recommended in
# https://docs.github.com/en/rest/guides/using-the-rest-api-to-interact-with-your-git-database?apiVersion=2022-11-28#checking-mergeability-of-pull-requests

set -euo pipefail

log() {
    echo "$@" >&2
}

if (( $# < 2 )); then
    log "Usage: $0 GITHUB_REPO PR_NUMBER"
    exit 99
fi
repo=$1
prNumber=$2

# Retry the API query this many times
retryCount=5
# Start with 5 seconds, but double every retry
retryInterval=5

while true; do
    log "Checking whether the pull request can be merged"
    prInfo=$(gh api \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "/repos/$repo/pulls/$prNumber")

    # Non-open PRs won't have their mergeability computed no matter what
    state=$(jq -r .state <<< "$prInfo")
    if [[ "$state" != open ]]; then
        log "PR is not open anymore"
        exit 2
    fi

    mergeable=$(jq -r .mergeable <<< "$prInfo")
    if [[ "$mergeable" == "null" ]]; then
        if (( retryCount == 0 )); then
            log "Not retrying anymore. It's likely that GitHub is having internal issues: check https://www.githubstatus.com/"
            exit 1
        else
            (( retryCount -= 1 )) || true

            # null indicates that GitHub is still computing whether it's mergeable
            # Wait a couple seconds before trying again
            log "GitHub is still computing whether this PR can be merged, waiting $retryInterval seconds before trying again ($retryCount retries left)"
            sleep "$retryInterval"

            (( retryInterval *= 2 )) || true
        fi
    else
        break
    fi
done

if [[ "$mergeable" == "true" ]]; then
    log "The PR can be merged"
    jq -r .merge_commit_sha <<< "$prInfo"
else
    log "The PR has a merge conflict"
    exit 1
fi
