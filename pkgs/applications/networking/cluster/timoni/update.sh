#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix jq
set -euo pipefail

PKG_DIR=$(dirname "${BASH_SOURCE[@]}")
FILE="$PKG_DIR/default.nix"
NIXPKGS_ROOT=$(cd $PKG_DIR && git rev-parse --show-toplevel)
ATTR="timoni"

PREV_VERSION=$(nix eval --raw -f $NIXPKGS_ROOT/default.nix $ATTR.version)
LATEST_TAG=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} --silent https://api.github.com/repos/stefanprodan/timoni/releases/latest | jq -r '.tag_name')
NEXT_VERSION=$(echo ${LATEST_TAG} | sed 's/^v//')

# update version
sed -i "s|$PREV_VERSION|$NEXT_VERSION|" "$FILE"

# update hash
PREV_HASH=$(nix eval --raw -f $NIXPKGS_ROOT/default.nix $ATTR.src.outputHash)
NEXT_HASH=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 $(nix-prefetch-url --unpack --type sha256 $(nix eval --raw -f $NIXPKGS_ROOT/default.nix $ATTR.src.url)))
sed -i "s|$PREV_HASH|$NEXT_HASH|" "$FILE"

# update vendor hash
PREV_VENDOR_HASH=$(nix eval --raw -f $NIXPKGS_ROOT/default.nix $ATTR.vendorHash)
EMPTY_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
sed -i "s|$PREV_VENDOR_HASH|$EMPTY_HASH|" "$FILE"

set +e
NEXT_VENDOR_HASH=$(nix-build $NIXPKGS_ROOT --no-out-link -A $ATTR 2>&1 | grep "got:" | cut -d':' -f2 | sed 's| ||g')
set -e

if [ -z "${NEXT_VENDOR_HASH:-}" ]; then
    echo "Update failed. NEXT_VENDOR_HASH is empty." >&2
    exit 1
fi

sed -i "s|$EMPTY_HASH|$NEXT_VENDOR_HASH|" "$FILE"

cat <<EOF
[{
    "attrPath": "$ATTR",
    "oldVersion": "$PREV_VERSION",
    "newVersion": "$NEXT_VERSION",
    "files": ["$PWD/default.nix.nix"]
}]
EOF
