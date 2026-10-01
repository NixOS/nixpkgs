#!/usr/bin/env nix-shell
#!nix-shell -i sh -p curl jq nix-prefetch-github coreutils gnused gnugrep
# shellcheck shell=sh
set -eu

# Directory of this script / the iaito package
SCRIPT_DIR="$(readlink -f "$(dirname "$0")")"
NIXFILE="$SCRIPT_DIR/package.nix"

# Determine latest release version: use $1 if provided, otherwise auto-detect
if [ -n "${1:-}" ]; then
    LATEST_VERSION="$1"
    echo "Using provided iaito version: $LATEST_VERSION"
else
    LATEST_VERSION=$(curl -s https://api.github.com/repos/radareorg/iaito/releases/latest | jq -r '.tag_name')
    echo "Latest iaito version: $LATEST_VERSION"
fi

CURRENT_VERSION=$(grep 'version = ' "$NIXFILE" | head -1 | sed 's/.*"\(.*\)".*/\1/')
echo "Current iaito version: $CURRENT_VERSION"

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
    echo "iaito is already up to date"
    exit 0
fi

# Update main source version and hash
echo "Updating main source to $LATEST_VERSION..."
MAIN_HASH=$(nix-prefetch-github radareorg iaito --rev "$LATEST_VERSION" --json | jq -r '.hash')
echo "  New main hash: $MAIN_HASH"

sed -i "s|version = \"$CURRENT_VERSION\"|version = \"$LATEST_VERSION\"|" "$NIXFILE"
sed -i "/repo = \"iaito\";$/,/})/{s|hash = \".*\"|hash = \"$MAIN_HASH\"|}" "$NIXFILE"

# Update translations to latest master revision
echo "Updating iaito-translations to latest master..."
LATEST_TRANS_REV=$(curl -s https://api.github.com/repos/radareorg/iaito-translations/commits/master | jq -r '.sha')
echo "  Latest translations rev: $LATEST_TRANS_REV"

CURRENT_TRANS_REV=$(grep -A3 'repo = "iaito-translations"' "$NIXFILE" | grep 'rev = ' | sed 's/.*"\(.*\)".*/\1/')
echo "  Current translations rev: $CURRENT_TRANS_REV"

if [ "$LATEST_TRANS_REV" = "$CURRENT_TRANS_REV" ]; then
    echo "  Translations unchanged"
else
    echo "  Updating translations: $CURRENT_TRANS_REV -> $LATEST_TRANS_REV"
    TRANS_HASH=$(nix-prefetch-github radareorg iaito-translations --rev "$LATEST_TRANS_REV" --json | jq -r '.hash')
    echo "  New translations hash: $TRANS_HASH"

    sed -i "/repo = \"iaito-translations\"/,/})/{s|rev = \"$CURRENT_TRANS_REV\"|rev = \"$LATEST_TRANS_REV\"|}" "$NIXFILE"
    sed -i "/repo = \"iaito-translations\"/,/})/{s|hash = \".*\"|hash = \"$TRANS_HASH\"|}" "$NIXFILE"
fi

echo "Update complete. Please verify with: nix build .#iaito"
