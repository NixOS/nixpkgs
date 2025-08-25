#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gnugrep jq yq-go bash nix-update

set -eou pipefail

PACKAGE_DIR=$(realpath "$(dirname "$0")")

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/HemantKArya/BloomeeTunes/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//' | grep -o '^[^+]*')
RunNumber=$(echo "$latestTag" | grep -o '[^+]*$')

currentVersion=$(nix eval --raw --file . bloomeetunes.version)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

sed -i "s/\(tag = \"v\${version}+\)[0-9]\+/\1${RunNumber}/" "$PACKAGE_DIR/package.nix"

nix-update bloomeetunes --version $latestVersion

curl https://raw.githubusercontent.com/HemantKArya/BloomeeTunes/${latestTag}/pubspec.lock | yq eval --output-format=json --prettyPrint >$PACKAGE_DIR/pubspec.lock.json

$PACKAGE_DIR/update-gitHashes.py
