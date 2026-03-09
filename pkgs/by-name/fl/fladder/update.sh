#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq yq-go nix bash nix-update common-updater-scripts ripgrep

set -eou pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR"
while ! test -f flake.nix; do cd ..; done
NIXPKGS_DIR="$PWD"

latestVersion=$(
    list-git-tags --url=https://github.com/DonutWare/Fladder |
    rg '^v(.*)' -r '$1' |
    sort --version-sort |
    tail -n1
)

currentVersion=$(nix eval --raw --file . fladder.version)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

nix-update --version="$latestVersion" fladder

curl --fail --silent "https://raw.githubusercontent.com/DonutWare/Fladder/v${latestVersion}/pubspec.lock" | yq eval --output-format=json --prettyPrint >"$PACKAGE_DIR"/pubspec.lock.json

$(nix eval --file "$NIXPKGS_DIR" dart.fetchGitHashesScript) --input "$PACKAGE_DIR"/pubspec.lock.json --output "$PACKAGE_DIR"/git-hashes.json
