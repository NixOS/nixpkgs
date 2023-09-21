#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq coreutils

set -euo pipefail

owner=tconbeer
repo=harlequin
latestVersion=$(curl "https://api.github.com/repos/$owner/$repo/releases/latest" | jq -r '.tag_name' | sed 's/^v//')
currentVersion=$(nix-instantiate --eval --expr 'with import ./package.nix {}; harlequin.version' | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    # Skip update when already on the latest version.
    exit 0
fi

update-source-version harlequin "$latestVersion"
