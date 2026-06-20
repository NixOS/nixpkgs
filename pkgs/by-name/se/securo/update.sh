#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-github jq prefetch-npm-deps

set -eu -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd)"
SOURCES_FILE="$SCRIPT_DIR/sources.json"

LATEST_TAG=$(curl -sS "https://api.github.com/repos/securo-finance/securo/releases/latest" | jq -r '.tag_name')

VERSION="${LATEST_TAG#v}"
echo "Latest version: $VERSION"

HASH=$(nix-prefetch-github --json securo-finance securo --rev "$LATEST_TAG" | jq -r '.hash')
echo "Source hash: $HASH"

NPM_DEPS_HASH=$(prefetch-npm-deps <(curl -sSfL "https://raw.githubusercontent.com/securo-finance/securo/$LATEST_TAG/frontend/package-lock.json"))
echo "npmDepsHash: $NPM_DEPS_HASH"

cat > "$SOURCES_FILE" <<EOF
{
  "version": "$VERSION",
  "hash": "$HASH",
  "npmDepsHash": "$NPM_DEPS_HASH"
}
EOF

echo "Wrote $SOURCES_FILE"
