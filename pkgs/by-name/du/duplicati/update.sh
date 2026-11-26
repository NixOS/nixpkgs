#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-github

set -euo pipefail

OWNER=duplicati
REPO=duplicati

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
TARGET="$SCRIPT_DIR/package.nix"

github_api() {
  if [[ -n ${GITHUB_TOKEN:-} ]]; then
    curl -fsSL -u ":$GITHUB_TOKEN" "$1"
  else
    curl -fsSL "$1"
  fi
}

github_hash() {
  nix-prefetch-github "$1" "$2" --rev "$3" | jq -er '.hash'
}

TAG=$(github_api "https://api.github.com/repos/$OWNER/$REPO/tags" |
  jq -r '.[].name' |
  grep -E '^v[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+_stable_' |
  sort -Vr |
  sed -n '1p')
IFS=_ read -r VERSION CHANNEL DATE <<< "${TAG#v}"
HASH=$(github_hash "$OWNER" "$REPO" "$TAG")

NGCLIENT_VERSION=$(curl -fsSL \
  "https://raw.githubusercontent.com/$OWNER/$REPO/$TAG/Duplicati/Server/webroot/ngclient/package.json" |
  jq -er '.dependencies["@duplicati/ngclient"]' |
  sed 's/^[^0-9]*//')
NGCLIENT_HASH=$(curl -fsSL \
  "https://registry.npmjs.org/@duplicati%2fngclient/$NGCLIENT_VERSION" |
  jq -er '.dist.integrity')

printf 'Duplicati %s (%s, %s)\nngclient %s\n' \
  "$VERSION" "$CHANNEL" "$DATE" "$NGCLIENT_VERSION"
printf 'Source hash: %s\nngclient tarball integrity: %s\n' \
  "$HASH" "$NGCLIENT_HASH"

sed -i \
  -e "/ngclientVersion = /c\  ngclientVersion = \"$NGCLIENT_VERSION\";" \
  -e "/ngclientHash = /c\  ngclientHash = \"$NGCLIENT_HASH\";" \
  -e "/version = \"/c\  version = \"$VERSION\";" \
  -e "/channel = \"/c\  channel = \"$CHANNEL\";" \
  -e "/buildDate = \"/c\  buildDate = \"$DATE\";" \
  -e "/hash = \"/c\    hash = \"$HASH\";" \
  "$TARGET"

. "$(nix-build . -A duplicati.fetch-deps --no-out-link)"
