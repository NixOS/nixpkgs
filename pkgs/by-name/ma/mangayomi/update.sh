#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq yq-go nix bash nix-update

set -eou pipefail

PACKAGE_DIR=$(realpath "$(dirname "$0")")

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --fail --silent https://api.github.com/repos/kodjodevf/mangayomi/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//')

currentVersion=$(nix eval --raw --file . mangayomi.version)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update --version $latestVersion --subpackage rustDep mangayomi

curl --fail --silent https://raw.githubusercontent.com/kodjodevf/mangayomi/${latestTag}/pubspec.lock | yq eval --output-format=json --prettyPrint >$PACKAGE_DIR/pubspec.lock.json

$(nix eval --file . dart.fetchGitHashesScript) --input $PACKAGE_DIR/pubspec.lock.json --output $PACKAGE_DIR/git-hashes.json
