#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq yq-go nix bash nix-update

set -eou pipefail

PACKAGE_DIR=$(realpath "$(dirname "$0")")

latestTag=$(curl --fail --location --silent ${GITHUB_TOKEN:+--user ":$GITHUB_TOKEN"} https://api.github.com/repos/chen08209/FlClash/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//')

currentVersion=$(nix eval --file . --raw flclash.version)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update --subpackage core --use-github-releases flclash

curl --fail --location --silent https://raw.githubusercontent.com/chen08209/FlClash/${latestTag}/pubspec.lock | yq eval --output-format=json --prettyPrint >$PACKAGE_DIR/pubspec.lock.json
