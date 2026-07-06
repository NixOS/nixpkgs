#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts gnused nix coreutils
#shellcheck shell=bash
#shellcheck source=/dev/null

set -euo pipefail

latestVersion=$(curl -s ${GITHUB_TOKEN:+ -H "Authorization: Bearer $GITHUB_TOKEN"} https://api.github.com/repos/recyclarr/recyclarr/releases?per_page=1 \
    | jq -r ".[0].tag_name" \
    | sed 's/^v//')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; recyclarr.version or (lib.getVersion recyclarr)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "recyclarr is up-to-date: $currentVersion"
    exit 0
fi

update-source-version recyclarr "$latestVersion"

. "$(nix-build . -A recyclarr.fetch-deps --no-out-link)"
