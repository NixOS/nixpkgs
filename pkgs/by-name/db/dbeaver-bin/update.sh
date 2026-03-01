#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts
BASEDIR="$(dirname "$0")/../../../.."

set -euo pipefail

latestVersion=$(curl "https://api.github.com/repos/dbeaver/dbeaver/tags" | jq -r '.[0].name')
currentVersion=$(nix-instantiate --eval -E "with import ${BASEDIR} {}; lib.getVersion dbeaver-bin" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "x86_64-linux linux.gtk.x86_64.tar.gz" \
    "aarch64-linux linux.gtk.aarch64.tar.gz" \
    "x86_64-darwin macos-x86_64.dmg" \
    "aarch64-darwin macos-aarch64.dmg"
do
    # shellcheck disable=SC2086 # $i is intentionally splitted to $1 and $2
    set -- $i
    prefetch=$(nix-prefetch-url "https://github.com/dbeaver/dbeaver/releases/download/$latestVersion/dbeaver-ce-$latestVersion-$2")
    hash=$(nix-hash --type sha256 --to-sri "$prefetch")

    (cd "$BASEDIR" && update-source-version dbeaver-bin "$latestVersion" "$hash" --system="$1" --ignore-same-version)
done
