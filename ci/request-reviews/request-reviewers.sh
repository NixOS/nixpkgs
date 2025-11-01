#!/usr/bin/env bash

# Request reviewers for a PR, reading line-separated usernames/teams on stdin,
# filtering for valid reviewers before using the API endpoint to request reviews:
# https://docs.github.com/en/rest/pulls/review-requests?apiVersion=2022-11-28#request-reviewers-for-a-pull-request
#
# Example:
#   $ request-reviewers.sh NixOS/nixpkgs 123456 someUser <<-EOF
#   someUser
#   anotherUser
#   NixOS/someTeam
#   NixOS/anotherTeam
#   EOF

set -euo pipefail

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' exit

log() {
    echo "$@" >&2
}

effect() {
    if [[ -n "${DRY_MODE:-}" ]]; then
        log "Skipping in dry mode:" "${@@Q}"
    else
        "$@"
    fi
}

if (( "$#" < 3 )); then
    log "Usage: $0 BASE_REPO PR_NUMBER PR_AUTHOR"
    exit 1
fi

baseRepo=$1
prNumber=$2
prAuthor=$3

org="${baseRepo%/*}"
repo="${baseRepo#*/}"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' exit

declare -A users=() teams=()

while read -r handle && [[ -n "$handle" ]]; do
    if [[ "$handle" =~ (.*)/(.*) ]]; then
        if [[ "${BASH_REMATCH[1]}" != "$org" ]]; then
            log "Team $handle is not part of the $org org, ignoring"
        else
            teams[${BASH_REMATCH[2],,}]=
        fi
    else
        users[${handle,,}]=
    fi
done

log "Checking users: ${!users[*]}"
log "Checking teams: ${!teams[*]}"

# Cannot request a review from the author
if [[ -v users[${prAuthor,,}] ]]; then
    log "Avoiding review request for PR author $prAuthor"
    unset 'users[${prAuthor,,}]'
fi

# And we don't want to rerequest reviews from people or teams who already reviewed
log -e "Checking if users/teams have already reviewed the PR"

# shellcheck disable=SC2016
# A graphql query to get all reviewers of a PR, including both users and teams
# on behalf of which a review was done.
# The REST API doesn't have an end-point for figuring out the on-behalfness of reviews
all_reviewers_query='
query($owner: String!, $repo: String!, $pr: Int!, $endCursor: String) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $pr) {
      reviews(first: 100, after: $endCursor) {
        nodes {
          author {
            login
          }
          onBehalfOf(first: 100) {
            nodes {
              slug
            }
          }
        }
        pageInfo {
          hasNextPage
          endCursor
        }
      }
    }
  }
}
'

gh api graphql \
    -H "Accept: application/vnd.github+json" \
    --paginate \
    -f query="$all_reviewers_query" \
    -F owner="$org" \
    -F repo="$repo" \
    -F pr="$prNumber" \
    > "$tmp/already-reviewed-by-response"

readarray -t userReviewers < <(jq -r '.data.repository.pullRequest.reviews.nodes[].author.login' "$tmp/already-reviewed-by-response")
log "PR is already reviewed by these users: ${userReviewers[*]}"
for user in "${userReviewers[@]}"; do
    if [[ -v users[${user,,}] ]]; then
        log "Avoiding review request for user $user, who has already left a review"
        unset 'users[${user,,}]'
    fi
done

readarray -t teamReviewers < <(jq -r '.data.repository.pullRequest.reviews.nodes[].onBehalfOf.nodes[].slug' "$tmp/already-reviewed-by-response")
log "PR is already reviewed by these teams: ${teamReviewers[*]}"
for team in "${teamReviewers[@]}"; do
    if [[ -v teams[${team,,}] ]]; then
        log "Avoiding review request for team $team, who has already left a review"
        unset 'teams[${team,,}]'
    fi
done

log -e "Checking that all users/teams can be requested for review"

for user in "${!users[@]}"; do
    if ! gh api "/repos/$baseRepo/collaborators/$user" >&2; then
        log "User $user cannot be requested for review because they don't exist or are not a repository collaborator, ignoring. Probably missed the automated invite to the maintainers team (see <https://github.com/NixOS/nixpkgs/issues/234293>)"
        unset 'users[$user]'
    fi
done
for team in "${!teams[@]}"; do
    if ! gh api "/orgs/$org/teams/$team/repos/$baseRepo" >&2; then
        log "Team $team cannot be requested for review because it doesn't exist or has no repository permissions, ignoring. Probably wasn't added to the nixpkgs-maintainers team (see https://github.com/NixOS/nixpkgs/tree/master/maintainers#maintainer-teams)"
        unset 'teams[$team]'
    fi
done

log "Would request reviews from users: ${!users[*]}"
log "Would request reviews from teams: ${!teams[*]}"

if (( ${#users[@]} + ${#teams[@]} > 10 )); then
    log "Too many reviewers (users: ${!users[*]}, teams: ${!teams[*]}), skipping review requests"
    exit 0
fi

for user in "${!users[@]}"; do
    log "Requesting review from user $user"
    if ! response=$(effect gh api \
            --method POST \
            "/repos/$baseRepo/pulls/$prNumber/requested_reviewers" \
            -f "reviewers[]=$user"); then
        log "Failed to request review from user $user: $response"
    fi
done

for team in "${!teams[@]}"; do
    log "Requesting review from team $team"
    if ! response=$(effect gh api \
            --method POST \
            "/repos/$baseRepo/pulls/$prNumber/requested_reviewers" \
            -f "team_reviewers[]=$team"); then
        log "Failed to request review from team $team: $response"
    fi
done
