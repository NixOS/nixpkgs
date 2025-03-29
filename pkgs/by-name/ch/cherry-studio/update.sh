#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix bash coreutils nix-update

set -eou pipefail

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/CherryHQ/cherry-studio/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; cherry-studio.version or (lib.getVersion cherry-studio)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update cherry-studio --version "$latestVersion"
