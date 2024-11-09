#!/usr/bin/env nix-shell
#!nix-shell -I ./. -i bash -p common-updater-scripts jq

set -eEuo pipefail
test ${DEBUG:-0} -eq 1 && set -x

# Current version.
LATEST_NIXPKGS_VERSION=$(nix eval --raw .#geoserver.version 2>/dev/null)
UPDATE_NIX_OLD_VERSION=${UPDATE_NIX_OLD_VERSION:-$LATEST_NIXPKGS_VERSION}

# Maybe future version.
LATEST_GITHUB_VERSION=$(curl -s "https://api.github.com/repos/geoserver/geoserver/releases/latest" | jq -r '.tag_name')
UPDATE_NIX_NEW_VERSION=${UPDATE_NIX_NEW_VERSION:-$LATEST_GITHUB_VERSION}

SMALLEST_VERSION=$(printf "$UPDATE_NIX_OLD_VERSION\n$UPDATE_NIX_NEW_VERSION" | sort --version-sort | head -n 1)

if [[ "$SMALLEST_VERSION" == "$UPDATE_NIX_NEW_VERSION" ]]; then
  echo "geoserver is up-to-date: $SMALLEST_VERSION"
  exit 0
fi

echo "Updating geoserver..."
update-source-version geoserver "$UPDATE_NIX_NEW_VERSION"

cd "$(dirname "$(readlink -f "$0")")"

EXT_NAMES=($(grep -o -E "hash = .*?; # .*$" ./extensions.nix | sed 's/.* # //' | sort))

if [[ $# -gt 0 ]] ; then
    EXT_NAMES=(${@:1})
fi

for EXT_NAME in "${EXT_NAMES[@]}" ; do
    echo "Updating extension $EXT_NAME..."
    URL="mirror://sourceforge/geoserver/GeoServer/${UPDATE_NIX_NEW_VERSION}/extensions/geoserver-${UPDATE_NIX_NEW_VERSION}-${EXT_NAME}-plugin.zip"
    HASH=$(nix-hash --to-sri --type sha256 $(nix-prefetch-url --unpack "$URL"))
    sed -i "s@version = \".*\"; # $EXT_NAME@version = \"$UPDATE_NIX_NEW_VERSION\"; # $EXT_NAME@" ./extensions.nix
    sed -i "s@hash = \".*\"; # $EXT_NAME@hash = \"$HASH\"; # $EXT_NAME@" ./extensions.nix
done

cd -
