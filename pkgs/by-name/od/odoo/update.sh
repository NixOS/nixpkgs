#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix coreutils nix-prefetch

set -euo pipefail

VERSION="17.0" # must be incremented manually

RELEASE="$(
    curl "https://nightly.odoo.com/$VERSION/nightly/src/" |
        sed -nE 's/.*odoo_'"$VERSION"'.(20[0-9]{6}).tar.gz.*/\1/p' |
        tail -n 1
)"

latestVersion="$VERSION.$RELEASE"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; odoo.version or (lib.getVersion odoo)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "odoo is up-to-date: $currentVersion"
    exit 0
fi

cd "$(dirname "${BASH_SOURCE[0]}")"

sed -ri "s| hash.+ # odoo| hash = \"$(nix-prefetch -q fetchzip --url "https://nightly.odoo.com/${VERSION}/nightly/src/odoo_${latestVersion}.zip")\"; # odoo|g" package.nix
sed -ri "s|, odoo_version \? .+|, odoo_version ? \"$VERSION\"|" package.nix
sed -ri "s|, odoo_release \? .+|, odoo_release ? \"$RELEASE\"|" package.nix
