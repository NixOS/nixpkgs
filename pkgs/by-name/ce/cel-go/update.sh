#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix bash nix-update

set -eou pipefail

PACKAGE_DIR=$(realpath $(dirname $0))

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/google/cel-go/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; cel-go.version or (lib.getVersion cel-go)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update cel-go
nix-update cel-go.cel-spec
