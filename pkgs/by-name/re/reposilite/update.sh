#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

# shellcheck shell=bash

set -euo pipefail

latestVersion=$(list-git-tags --url=https://github.com/dzikoysk/reposilite | grep -E '^[0-9.]+$' | sort --reverse --version-sort | head -n 1)

update-source-version reposilite "$latestVersion"

jq -r 'keys[]' ./pkgs/by-name/re/reposilite/plugins.json | while read -r plugin; do
    tmpfile=$(mktemp)
    curl -o "$tmpfile" "https://maven.reposilite.com/releases/com/reposilite/plugin/$plugin-plugin/$latestVersion/$plugin-plugin-$latestVersion-all.jar"
    hash=$(nix-hash --sri --flat --type sha256 "$tmpfile")

    updatedContent=$(jq ".$plugin = \"$hash\"" ./pkgs/by-name/re/reposilite/plugins.json)
    echo -E "$updatedContent" > ./pkgs/by-name/re/reposilite/plugins.json
done

