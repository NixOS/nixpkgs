#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-github

set -euo pipefail

OWNNER="duplicati"
REPO="duplicati"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
TARGET="$SCRIPT_DIR/package.nix"

TAG=$(curl -s "https://api.github.com/repos/$OWNNER/$REPO/tags" |
  jq -r '.[].name' |
  grep -E '^v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+_stable_' |
  sort -Vr |
  head -n1)

VERSION=$(echo "$TAG" | cut -d_ -f1 | sed 's/^v//')
CHANNEL=$(echo "$TAG" | cut -d_ -f2)
DATE=$(echo "$TAG" | cut -d_ -f3)

HASH=$(nix-prefetch-github $OWNNER $REPO --rev "$TAG" |
  jq -r '.hash')

sed -i \
  -e "/version = \"/c\  version = \"$VERSION\";" \
  -e "/channel = \"/c\  channel = \"$CHANNEL\";" \
  -e "/buildDate = \"/c\  buildDate = \"$DATE\";" \
  -e "/hash = \"/c\    hash = \"$HASH\";" \
  "$TARGET"

. "$(nix-build . -A duplicati.fetch-deps --no-out-link)"
