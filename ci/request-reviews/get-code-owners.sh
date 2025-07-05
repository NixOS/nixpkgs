#!/usr/bin/env bash

# Get the code owners of the files changed by a PR, returning one username per line

set -euo pipefail

log() {
    echo "$@" >&2
}

if (( "$#" < 4 )); then
    log "Usage: $0 GIT_REPO OWNERS_FILE BASE_REF HEAD_REF"
    exit 1
fi

gitRepo=$1
ownersFile=$2
baseRef=$3
headRef=$4

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' exit

git -C "$gitRepo" diff --name-only --merge-base "$baseRef" "$headRef" > "$tmp/touched-files"
readarray -t touchedFiles < "$tmp/touched-files"
log "This PR touches ${#touchedFiles[@]} files"

# Get the owners file from the base, because we don't want to allow PRs to
# remove code owners to avoid pinging them
git -C "$gitRepo" show "$baseRef":"$ownersFile" > "$tmp"/codeowners

# Associative array with the user as the key for easy de-duplication
# Make sure to always lowercase keys to avoid duplicates with different casings
declare -A users=()

for file in "${touchedFiles[@]}"; do
    result=$(codeowners --file "$tmp"/codeowners "$file")

    # Remove the file prefix and trim the surrounding spaces
    read -r owners <<< "${result#"$file"}"
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

        if [[ "$entry" =~ (.*)/(.*) ]]; then
            # Teams look like $org/$team
            org=${BASH_REMATCH[1]}
            team=${BASH_REMATCH[2]}

            # Instead of requesting a review from the team itself,
            # we request reviews from the individual users.
            # This is because once somebody from a team reviewed the PR,
            # the API doesn't expose that the team was already requested for a review,
            # so we wouldn't be able to avoid rerequesting reviews
            # without saving some some extra state somewhere

            # We could also consider implementing a more advanced heuristic
            # in the future that e.g. only pings one team member,
            # but escalates to somebody else if that member doesn't respond in time.
            gh api \
                --cache=1h \
                -H "Accept: application/vnd.github+json" \
                -H "X-GitHub-Api-Version: 2022-11-28" \
                "/orgs/$org/teams/$team/members" \
                --jq '.[].login' > "$tmp/team-members"
            readarray -t members < "$tmp/team-members"
            log "Team $entry has these members: ${members[*]}"

            for user in "${members[@]}"; do
                users[${user,,}]=
            done
        else
            # Everything else is a user
            users[${entry,,}]=
        fi
    done

done

printf "%s\n" "${!users[@]}"
