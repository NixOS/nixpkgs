#!/usr/bin/env nix
#!nix shell --ignore-environment .#cacert .#coreutils .#curl .#bash .#jq .#nix --command bash
# Update script for incus-spawn in nixpkgs.
# Invoked by: nix-shell maintainers/scripts/update.nix --argstr commit true --argstr package incus-spawn
# Or manually: ./update.sh [version]

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

REPO="Sanne/incus-spawn"
PACKAGE_NIX="package.nix"

# Determine target version
if [[ -n "${1:-}" ]]; then
    VERSION="${1#v}"
else
    VERSION=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | jq -r '.tag_name' | sed 's/^v//')
fi

CURRENT=$(grep 'version = "' "$PACKAGE_NIX" | head -1 | sed 's/.*"\(.*\)".*/\1/')

if [[ "$VERSION" == "$CURRENT" ]]; then
    echo "incus-spawn is already at $VERSION"
    exit 0
fi

echo "Updating incus-spawn: $CURRENT -> $VERSION"

# Compute SRI hashes for each artifact
hash_for() {
    local url="$1"
    nix hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url --type sha256 "$url" 2>/dev/null)"
}

BASE_URL="https://github.com/$REPO/releases/download/v$VERSION"

HASH_AMD64=$(hash_for "$BASE_URL/incus-spawn-linux-amd64")
HASH_AARCH64=$(hash_for "$BASE_URL/incus-spawn-linux-aarch64")
HASH_MACOS=$(hash_for "$BASE_URL/incus-spawn-macos-aarch64")
HASH_GIT_REMOTE=$(hash_for "$BASE_URL/git-remote-isx")

echo "  linux-amd64:    $HASH_AMD64"
echo "  linux-aarch64:  $HASH_AARCH64"
echo "  macos-aarch64:  $HASH_MACOS"
echo "  git-remote-isx: $HASH_GIT_REMOTE"

# Update package.nix in place
sed -i \
    -e "0,/version = \"[^\"]*\"/s/version = \"[^\"]*\"/version = \"$VERSION\"/" \
    -e "/x86_64-linux/,/};/{s|hash = \"[^\"]*\"|hash = \"$HASH_AMD64\"|}" \
    -e "/aarch64-linux/,/};/{s|hash = \"[^\"]*\"|hash = \"$HASH_AARCH64\"|}" \
    -e "/aarch64-darwin/,/};/{s|hash = \"[^\"]*\"|hash = \"$HASH_MACOS\"|}" \
    -e "/git-remote-isx/,/};/{s|hash = \"[^\"]*\"|hash = \"$HASH_GIT_REMOTE\"|}" \
    "$PACKAGE_NIX"

echo "Updated $PACKAGE_NIX to $VERSION"
