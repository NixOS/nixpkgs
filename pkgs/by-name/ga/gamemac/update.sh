#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl gnused nix

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

ROLLING_URL="https://api-international-gamehub.xiaoji.com/game/download/mac/en"
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"

# Resolve rolling URL to stable CDN URL (strip query string)
DIRECT_URL=$(curl -fsSL -A "$UA" -w "%{url_effective}" -o /dev/null "$ROLLING_URL")
CDN_URL="${DIRECT_URL%%\?*}"

# Extract version from CDN filename (e.g. .../GameHub_en_0.8.328.dmg)
VERSION=$(basename "$CDN_URL" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

CURRENT=$(grep 'version = ' package.nix | head -1 | grep -oE '"[0-9.]+"' | tr -d '"')
if [ "$VERSION" = "$CURRENT" ]; then
  echo "Already at $VERSION"
  exit 0
fi

HASH=$(nix-prefetch-url --name "GameHub_en_${VERSION}.dmg" --type sha256 "$CDN_URL")
SRI=$(nix-hash --to-sri --type sha256 "$HASH")

sed -i \
  -e "s|version = \"[^\"]*\"|version = \"$VERSION\"|" \
  -e "s|https://gamehub-cdn\.masnet\.cn/uploads/upgrade/[^\"]*|$CDN_URL|" \
  -e "s|hash = \"sha256-[^\"]*\"|hash = \"$SRI\"|" \
  package.nix

echo "Updated $CURRENT -> $VERSION"
