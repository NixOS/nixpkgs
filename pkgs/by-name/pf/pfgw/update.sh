#!/usr/bin/env bash
set -euo pipefail

PACKAGE_DIR="pkgs/by-name/pf/pfgw"
PACKAGE_FILE="$PACKAGE_DIR/package.nix"

echo "Checking for pfgw SVN updates..."
SVN_URL="https://svn.code.sf.net/p/openpfgw/code/"
SVN_INFO=$(nix-shell -p subversion --run "LC_ALL=C svn info $SVN_URL")
LATEST_REV=$(echo "$SVN_INFO" | grep "Last Changed Rev" | cut -d' ' -f4)
LATEST_DATE=$(echo "$SVN_INFO" | grep "Last Changed Date" | cut -d' ' -f4)
CURRENT_REV=$(grep -oP 'rev = "\K[0-9]+' "$PACKAGE_FILE")

if [ "$LATEST_REV" -gt "$CURRENT_REV" ]; then
    echo "New pfgw revision found: $LATEST_REV (current: $CURRENT_REV)"

    PREFETCH_OUTPUT=$(nix-shell -p nix-prefetch-svn --run "nix-prefetch-svn $SVN_URL $LATEST_REV" 2>&1)
    if echo "$PREFETCH_OUTPUT" | grep -q "hash is"; then
        NEW_PFGW_HASH=$(echo "$PREFETCH_OUTPUT" | grep -oP 'hash is \K[a-z0-9]+')
        NEW_PFGW_PATH=$(echo "$PREFETCH_OUTPUT" | grep -oP 'path is \K.*')
    else
        NEW_PFGW_HASH=$(echo "$PREFETCH_OUTPUT" | tail -n 1)
        NEW_PFGW_PATH=$(echo "$PREFETCH_OUTPUT" | grep -oP 'path is \K.*')
    fi

    if [[ -z "$NEW_PFGW_HASH" ]]; then
        echo "Failed to extract hash from nix-prefetch-svn output:"
        echo "$PREFETCH_OUTPUT"
        exit 1
    fi

    if [[ -z "$NEW_PFGW_PATH" ]]; then
         echo "Failed to extract path from nix-prefetch-svn output. Cannot determine version."
         echo "$PREFETCH_OUTPUT"
         exit 1
    fi

    NEW_PFGW_HASH_SRI=$(nix hash convert --hash-algo sha256 --to sri "$NEW_PFGW_HASH")

    VERSION_HEADER="$NEW_PFGW_PATH/pform/pfgw/pfgw_version.h"
    if [[ ! -f "$VERSION_HEADER" ]]; then
        echo "Could not find version header at $VERSION_HEADER"
        exit 1
    fi

    RAW_VERSION=$(grep -oP '#define\s+RELEASE_VERSION\s+"\K[^"]+' "$VERSION_HEADER")

    NEW_DATE="$LATEST_DATE"

    NEW_PFGW_VERSION="${RAW_VERSION}-unstable-${NEW_DATE}"

    echo "Updating pfgw..."
    sed -i "s/rev = \"$CURRENT_REV\";/rev = \"$LATEST_REV\";/" "$PACKAGE_FILE"
    sed -i "/rev = \"$LATEST_REV\";/{n;s|hash = \".*\";|hash = \"$NEW_PFGW_HASH_SRI\";|}" "$PACKAGE_FILE"

    sed -i "s/version = \"[^\"]*-unstable-[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\";/version = \"$NEW_PFGW_VERSION\";/" "$PACKAGE_FILE"
else
    echo "pfgw is already at the latest revision ($CURRENT_REV)"
fi

echo "Checking pinned gwnum dependencies..."
PFGW_SRC_PATH=$(nix build --impure --no-link --print-out-paths --expr "(import ./. { config.allowUnfree = true; }).pfgw.src")
GWNUM_H="$PFGW_SRC_PATH/packages/gwnum/gwnum.h"

GWNUM_VERSION_RAW=$(grep -oP '#define GWNUM_VERSION[[:space:]]+"\K[^"]+' "$GWNUM_H")
GWNUM_MAJOR=$(echo "$GWNUM_VERSION_RAW" | cut -d. -f1)
GWNUM_MINOR=$(echo "$GWNUM_VERSION_RAW" | cut -d. -f2)
GWNUM_MINOR_PADDED=$(printf "%02d" "${GWNUM_MINOR#0}")

echo "pfgw expects gwnum: $GWNUM_MAJOR.$GWNUM_MINOR"

BASE_URL="https://download.mersenne.ca/gimps/v$GWNUM_MAJOR/$GWNUM_MAJOR.$GWNUM_MINOR_PADDED/"
if ! curl --output /dev/null --silent --head --fail "$BASE_URL"; then
    BASE_URL="https://download.mersenne.ca/gimps/v$GWNUM_MAJOR/_pre-release/$GWNUM_MAJOR.$GWNUM_MINOR_PADDED/"
fi

echo "Scanning $BASE_URL..."
LATEST_PATCH=$(curl -s "$BASE_URL" | \
    grep -oP "p95v${GWNUM_MAJOR}${GWNUM_MINOR_PADDED}b\K[0-9]+(?=\.source\.zip)" | \
    sort -rn | head -n 1)

if [[ -z "$LATEST_PATCH" ]]; then
    echo "No patches found."
    exit 1
fi

NEW_GWNUM_VERSION="${GWNUM_MAJOR}.${GWNUM_MINOR_PADDED}b${LATEST_PATCH}"
echo "Latest pinned version should be: $NEW_GWNUM_VERSION"

NEW_GWNUM_URL="${BASE_URL}p95v${GWNUM_MAJOR}${GWNUM_MINOR_PADDED}b${LATEST_PATCH}.source.zip"
NEW_GWNUM_HASH=$(nix-prefetch-url "$NEW_GWNUM_URL")
NEW_GWNUM_HASH_SRI=$(nix hash convert --hash-algo sha256 --to sri "$NEW_GWNUM_HASH")

sed -i "0,/version = \".*\";/s||version = \"$NEW_GWNUM_VERSION\";|" "$PACKAGE_FILE"
sed -i "0,/hash = \".*\";/s||hash = \"$NEW_GWNUM_HASH_SRI\";|" "$PACKAGE_FILE"

echo "Update complete! Pinned gwnum is now $NEW_GWNUM_VERSION"
