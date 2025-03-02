#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused jq yq nix bash coreutils nix-update

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/GopeedLab/gopeed/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; gopeed.version or (lib.getVersion gopeed)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update gopeed.libgopeed

curl https://raw.githubusercontent.com/GopeedLab/gopeed/${latestTag}/ui/flutter/pubspec.lock | yq . >$ROOT/pubspec.lock.json
