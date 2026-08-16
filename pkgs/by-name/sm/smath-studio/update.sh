#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq nix

set -euo pipefail

# Get the absolute path to the directory containing this script
DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
PACKAGE_FILE="$DIR/package.nix"

echo "Checking for updates..."

HTML=$(curl -s "https://smath.com/en-US/view/SMathStudio/download")

# Get the first .AppImage link
REL_URL=$(echo "$HTML" | grep -oP 'href="\K([^"]+x86_64[^"]+\.AppImage)(?=")' | head -n 1)

if [[ -z "$REL_URL" ]]; then
  echo "Error: Could not find the AppImage download link on the page."
  exit 1
fi

URL="https://smath.com$REL_URL"

# Extract the version from the filename
VERSION=$(echo "$REL_URL" | grep -oP 'SMathStudioDesktop\.\K(\d+_\d+_\d+_\d+)' | tr '_' '.')

# Read the current version from package.nix
CURRENT_VERSION=$(grep -oP 'version = "\K([^"]+)' "$PACKAGE_FILE")

if [[ "$VERSION" == "$CURRENT_VERSION" ]]; then
  echo "smath-studio is already up to date ($VERSION)."
  exit 0
fi

echo "Updating smath-studio: $CURRENT_VERSION -> $VERSION"

echo "Downloading $URL to calculate hash..."
HASH=$(nix store prefetch-file "$URL" --json | jq -r .hash)

# Update the package.nix file
echo "Updating package.nix"
sed -i "s|version = \".*\";|version = \"$VERSION\";|" "$PACKAGE_FILE"
sed -i "s|url = \".*\";|url = \"$URL\";|" "$PACKAGE_FILE"
sed -i "s|hash = \".*\";|hash = \"$HASH\";|" "$PACKAGE_FILE"

echo "done"
