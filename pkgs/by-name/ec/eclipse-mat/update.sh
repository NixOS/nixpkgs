#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p bash curl gnused coreutils common-updater-scripts

set -euo pipefail

BASEDIR="$(dirname "$(readlink -f "$0")")/../../../.."
MIRROR="https://ftp.halifax.rwth-aachen.de/eclipse/mat"

baseVersion=$(curl -sL "$MIRROR/" |
    sed -n 's/.*href="\([0-9]\+\.[0-9]\+\.[0-9]\+\)\/".*/\1/p' |
    sort -V | tail -1)

latestVersion=$(curl -sL "$MIRROR/$baseVersion/rcp/" |
    sed -n 's/.*href="MemoryAnalyzer-\([0-9.]\+\)-linux\.gtk\.x86_64\.zip".*/\1/p' |
    sort -V | tail -1)

currentVersion=$(nix-instantiate --eval -E "with import $BASEDIR {}; lib.getVersion eclipse-mat" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ -z "$latestVersion" ]]; then
    echo "could not determine the latest version" >&2
    exit 1
fi

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for target in \
    "x86_64-linux:linux.gtk.x86_64" \
    "aarch64-linux:linux.gtk.aarch64" \
    "aarch64-darwin:macosx.cocoa.aarch64"; do
    nixSystem="${target%%:*}"
    suffix="${target#*:}"

    prefetch=$(nix-prefetch-url "$MIRROR/$baseVersion/rcp/MemoryAnalyzer-$latestVersion-$suffix.zip")
    hash=$(nix-hash --type sha256 --to-sri "$prefetch")

    (cd "$BASEDIR" && update-source-version eclipse-mat "$latestVersion" "$hash" --system="$nixSystem" --ignore-same-version)
done
