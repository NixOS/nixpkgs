#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq yq nix bash nix-update

set -eou pipefail

PACKAGE_DIR=$(realpath "$(dirname "$0")")

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/kodjodevf/mangayomi/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//')

currentVersion=$(nix eval --raw --file . mangayomi.version)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update --subpackage rustDep mangayomi

curl -sL https://raw.githubusercontent.com/kodjodevf/mangayomi/${latestTag}/pubspec.lock | yq . >$PACKAGE_DIR/pubspec.lock.json

$PACKAGE_DIR/update-gitHashes.py
