#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused jq nix bash coreutils nix-update common-updater-scripts

set -eou pipefail

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/uazo/cromite/releases/latest | jq --raw-output .tag_name | sed 's/^v//')
latestVersion="${latestTag%-*}"
commit="${latestTag#*-}"

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; cromite.version or (lib.getVersion cromite)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

update-source-version cromite $commit --version-key=commit || true
nix-update cromite --version $latestVersion
