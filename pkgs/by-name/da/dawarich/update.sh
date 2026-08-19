#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bundix curl jq nix-update nix-prefetch-github prefetch-npm-deps gnused
set -e
set -o pipefail

OWNER="Freika"
REPO="dawarich"

old_version=$(nix-instantiate --eval -A 'dawarich.version' default.nix | tr -d '"')
version=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/$OWNER/$REPO/releases/latest" | jq -r ".tag_name")

echo "Updating to $version"

if [[ "$old_version" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

echo "Fetching source code $REVISION"
JSON=$(nix-prefetch-github "$OWNER" "$REPO" --rev "refs/tags/$version" 2>/dev/null)
HASH=$(echo "$JSON" | jq -r .hash)

cat > "$SCRIPT_DIR/sources.json" << EOF
{
  "version": "$version",
  "hash": "$HASH",
  "npmHash": "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
}
EOF

SOURCE_DIR="$(nix-build --no-out-link -A dawarich.src)"

echo "Creating gemset.nix"
bundix --lockfile="$SOURCE_DIR/Gemfile.lock" --gemfile="$SOURCE_DIR/Gemfile" --gemset="$SCRIPT_DIR/gemset.nix"
nixfmt "$SCRIPT_DIR/gemset.nix"

NPM_HASH="$(prefetch-npm-deps "$SOURCE_DIR/package-lock.json" 2>/dev/null)"
sed -i "s;sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=;$NPM_HASH;g" "$SCRIPT_DIR/sources.json"
