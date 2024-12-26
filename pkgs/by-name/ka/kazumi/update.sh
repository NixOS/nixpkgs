#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq yq nixVersions.latest bash coreutils nix-update

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/Predidit/Kazumi/releases/latest | jq --raw-output .tag_name)

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; kazumi.version or (lib.getVersion kazumi)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update kazumi

curl https://raw.githubusercontent.com/Predidit/Kazumi/${latestVersion}/pubspec.lock | yq . >$ROOT/pubspec.lock.json
