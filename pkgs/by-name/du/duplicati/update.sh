#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-github prefetch-npm-deps

set -euo pipefail

OWNNER="duplicati"
REPO="duplicati"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
TARGET="$SCRIPT_DIR/package.nix"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

TAG=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s "https://api.github.com/repos/$OWNNER/$REPO/tags" |
  jq -r '.[].name' |
  grep -E '^v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+_stable_' |
  sort -Vr |
  head -n1)

VERSION=$(echo "$TAG" | cut -d_ -f1 | sed 's/^v//')
CHANNEL=$(echo "$TAG" | cut -d_ -f2)
DATE=$(echo "$TAG" | cut -d_ -f3)

HASH=$(nix-prefetch-github $OWNNER $REPO --rev "$TAG" |
  jq -r '.hash')

curl -sL \
  -o "$TMP/package.json" \
  "https://raw.githubusercontent.com/$OWNNER/$REPO/$TAG/Duplicati/Server/webroot/ngclient/package.json"

NGCLIENT_VERSION=$(
  jq -r '.dependencies["@duplicati/ngclient"]' \
    "$TMP/package.json" |
    sed 's/^[^0-9]*//'
)

NGCLIENT_REV=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} \
  -s "https://api.github.com/search/commits?q=repo:duplicati/ngclient+$NGCLIENT_VERSION" |
  jq -r '.items[0].sha')

NGCLIENT_HASH=$(
  nix-prefetch-github $OWNNER ngclient --rev "$NGCLIENT_REV" |
    jq -r .hash
)

curl -sL \
  -o "$TMP/package-lock.json" \
  "https://raw.githubusercontent.com/$OWNNER/ngclient/$NGCLIENT_REV/package-lock.json"

NGCLIENT_NPM_DEPS_HASH="$(prefetch-npm-deps "$TMP"/package-lock.json)"

echo "version=$VERSION"
echo "channel=$CHANNEL"
echo "date=$DATE"

echo "ngclientVersion=$NGCLIENT_VERSION"
echo "ngclientRev=$NGCLIENT_REV"
echo "ngclientHash=$NGCLIENT_HASH"
echo "npmDepsHash=$NGCLIENT_NPM_DEPS_HASH"

sed -i \
  -e "/ngclientVersion = /c\  ngclientVersion = \"$NGCLIENT_VERSION\";" \
  -e "/ngclientRev = /c\  ngclientRev = \"$NGCLIENT_REV\";" \
  -e "/ngclientHash = /c\  ngclientHash = \"$NGCLIENT_HASH\";" \
  -e "/npmDepsHash = /c\    npmDepsHash = \"$NGCLIENT_NPM_DEPS_HASH\";" \
  -e "/version = \"/c\  version = \"$VERSION\";" \
  -e "/channel = \"/c\  channel = \"$CHANNEL\";" \
  -e "/buildDate = \"/c\  buildDate = \"$DATE\";" \
  -e "/hash = \"/c\    hash = \"$HASH\";" \
  "$TARGET"

. "$(nix-build . -A duplicati.fetch-deps --no-out-link)"
