#!/usr/bin/env bash
set -euo pipefail

PACKAGE_DIR="pkgs/by-name/gw/gwnum"
PACKAGE_FILE="$PACKAGE_DIR/package.nix"
GIMPS_URL="https://download.mersenne.ca/gimps/"

echo "Scanning $GIMPS_URL for the latest major version..."
LATEST_MAJOR=$(curl -s "$GIMPS_URL" | grep -oP 'v\K[0-9]+' | sort -rn | head -n 1)

MAJOR_URL="${GIMPS_URL}v${LATEST_MAJOR}/"
echo "Checking $MAJOR_URL for minor versions..."

LATEST_MINOR_DIR=$(curl -s "$MAJOR_URL" | \
    grep -oP 'href="/gimps/v[0-9]+/([^"]+)"' | \
    cut -d'"' -f2 | \
    rev | cut -d/ -f1 | rev | \
    grep -vE "parent|http" | \
    sort -V | \
    tail -n 1)

if [[ -z "$LATEST_MINOR_DIR" ]]; then
    echo "Could not find any minor version directories in $MAJOR_URL"
    exit 1
fi

BASE_URL="https://download.mersenne.ca/gimps/v$LATEST_MAJOR/${LATEST_MINOR_DIR}/"

if [[ "$LATEST_MINOR_DIR" == "_pre-release" ]]; then
    echo "Checking $BASE_URL for subdirectories..."
    SUB_DIR=$(curl -s "$BASE_URL" | \
        grep -oP 'href="/gimps/v[0-9]+/_pre-release/([^"]+)"' | \
        cut -d'"' -f2 | \
        rev | cut -d/ -f1 | rev | \
        grep -vE "parent|http" | \
        sort -V | \
        tail -n 1)
    if [[ -n "$SUB_DIR" ]]; then
        BASE_URL="${BASE_URL}${SUB_DIR}/"
    fi
fi

echo "Checking $BASE_URL for the latest source zip..."
LATEST_FILE=$(curl -s "$BASE_URL" | grep -oP 'p95v[0-9]+b[0-9]+\.source\.zip' | sort -V | tail -n 1)

if [[ -z "$LATEST_FILE" ]]; then
    echo "Could not find any source zips at $BASE_URL"
    exit 1
fi

REGEX="p95v([0-9]+)b([0-9]+)\.source\.zip"
if [[ $LATEST_FILE =~ $REGEX ]]; then
    MAJOR_MINOR_RAW="${BASH_REMATCH[1]}"
    PATCH_RAW="${BASH_REMATCH[2]}"

    if [[ ! "$MAJOR_MINOR_RAW" == "$LATEST_MAJOR"* ]]; then
        echo "Error: File major version mismatch ($MAJOR_MINOR_RAW vs $LATEST_MAJOR)"
        exit 1
    fi

    MINOR_PADDED="${MAJOR_MINOR_RAW#$LATEST_MAJOR}"

    NEW_VERSION="${LATEST_MAJOR}.${MINOR_PADDED}b${PATCH_RAW}"
else
    echo "Failed to parse filename components from $LATEST_FILE"
    exit 1
fi

echo "Latest Version detected: $NEW_VERSION"

NEW_URL="${BASE_URL}${LATEST_FILE}"
echo "Fetching new hash from $NEW_URL..."
NEW_HASH=$(nix-prefetch-url "$NEW_URL")
NEW_HASH_SRI=$(nix hash convert --hash-algo sha256 --to sri "$NEW_HASH")

echo "Updating $PACKAGE_FILE..."

sed -i 's/version ? "[^"]*"/version ? "'$NEW_VERSION'"/' "$PACKAGE_FILE"
sed -i 's|hash ? "[^"]*"|hash ? "'$NEW_HASH_SRI'"|' "$PACKAGE_FILE"

echo "Update complete! gwnum is now at $NEW_VERSION"
