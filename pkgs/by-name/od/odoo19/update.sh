#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix coreutils nix-prefetch
# shellcheck shell=bash

set -euo pipefail

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
PKG=$(basename "$SCRIPT_DIR")

LATEST="18" # increment manually
VERSION="${PKG/#odoo}"
VERSION="${VERSION:-$LATEST}.0"

RELEASE="$(
    curl "https://nightly.odoo.com/$VERSION/nightly/src/" |
        sed -nE 's/.*odoo_'"$VERSION"'.(20[0-9]{6}).tar.gz.*/\1/p' |
        tail -n 1
)"

latestVersion="$VERSION.$RELEASE"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; $PKG.version or (lib.getVersion $PKG)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "$PKG is up-to-date: $currentVersion"
    exit 0
fi

cd "$SCRIPT_DIR"

sed -ri "s| hash.+ # odoo| hash = \"$(nix-prefetch -q fetchzip --option extra-experimental-features flakes --url "https://nightly.odoo.com/${VERSION}/nightly/src/odoo_${latestVersion}.zip")\"; # odoo|g" package.nix
sed -ri "s|odoo_version = .+|odoo_version = \"$VERSION\";|" package.nix
sed -ri "s|odoo_release = .+|odoo_release = \"$RELEASE\";|" package.nix
