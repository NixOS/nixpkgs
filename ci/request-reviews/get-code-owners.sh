#!/usr/bin/env bash

# Get the code owners of the files changed by a PR, returning one username or team per line

set -euo pipefail

log() {
    echo "$@" >&2
}

if (( "$#" < 4 )); then
    log "Usage: $0 TOUCHED_FILES_FILE OWNERS_FILE"
    exit 1
fi

touchedFilesFile=$1
ownersFile=$2

readarray -t touchedFiles < "$touchedFilesFile"
log "This PR touches ${#touchedFiles[@]} files"

for file in "${touchedFiles[@]}"; do
    result=$(codeowners --file "$ownersFile" "$file")

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

        echo "$entry"
    done

done
