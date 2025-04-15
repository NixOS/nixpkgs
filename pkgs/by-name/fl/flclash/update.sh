#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused jq yq nix bash coreutils nix-update

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/chen08209/FlClash/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; flclash.version or (lib.getVersion flclash)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update --subpackage libclash flclash

curl https://raw.githubusercontent.com/chen08209/FlClash/${latestTag}/pubspec.lock | yq . >$ROOT/pubspec.lock.json
