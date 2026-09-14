#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p bash curl gnugrep gnused coreutils nix

set -euo pipefail

DIR="$(dirname "$(readlink -f "$0")")"
BASEDIR="$DIR/../../../.."

# Upstream publishes no version index; the downloads page lists every build.
latestUrl=$(curl -fsSL "https://drawthings.ai/downloads" |
    grep -oE 'https://static\.drawthings\.ai/DrawThings-[0-9.]+-[0-9a-f]{8}\.zip' |
    sort -Vu | tail -1)

if [[ -z "$latestUrl" ]]; then
    echo "no download link found on https://drawthings.ai/downloads" >&2
    exit 1
fi

latestVersion=${latestUrl##*/DrawThings-}
latestVersion=${latestVersion%%-*}

currentVersion=$(nix-instantiate --eval -E "with import $BASEDIR {}; lib.getVersion draw-things" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

hash=$(nix-hash --type sha256 --to-base16 "$(nix-prefetch-url "$latestUrl")")

if [[ "${latestUrl##*-}" != "${hash:0:8}.zip" ]]; then
    echo "$latestUrl is no longer named after its SHA-256 (${hash:0:8})" >&2
    exit 1
fi

sed -i \
    -e "s|^  version = \"[^\"]*\";|  version = \"$latestVersion\";|" \
    -e "s|^    sha256 = \"[^\"]*\";|    sha256 = \"$hash\";|" \
    "$DIR/package.nix"

echo "updated to $latestVersion"
