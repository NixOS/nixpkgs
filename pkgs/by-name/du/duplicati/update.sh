#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-github prefetch-npm-deps npm-lockfile-fix

set -euo pipefail

OWNER=duplicati
REPO=duplicati
NGCLIENT_REPO=ngclient
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
TARGET="$SCRIPT_DIR/package.nix"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

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
NGCLIENT_REV=$(github_api "https://api.github.com/search/commits?q=repo:$OWNER/$NGCLIENT_REPO+$NGCLIENT_VERSION" |
  jq -er '.items[0].sha')

NGCLIENT_SRC="$TMP/$NGCLIENT_REPO"
mkdir -p "$NGCLIENT_SRC"
curl -fsSL "https://github.com/$OWNER/$NGCLIENT_REPO/archive/$NGCLIENT_REV.tar.gz" |
  tar -xz -C "$NGCLIENT_SRC" --strip-components=1

npm-lockfile-fix -r "$NGCLIENT_SRC/package-lock.json"
NGCLIENT_HASH=$(nix hash path --sri "$NGCLIENT_SRC")
NGCLIENT_NPM_DEPS_HASH=$(prefetch-npm-deps "$NGCLIENT_SRC/package-lock.json")

printf 'Duplicati %s (%s, %s)\nngclient %s (%s)\n' \
  "$VERSION" "$CHANNEL" "$DATE" "$NGCLIENT_VERSION" "$NGCLIENT_REV"
printf 'Source hash: %s\nngclient hash: %s\nnpmDepsHash: %s\n' \
  "$HASH" "$NGCLIENT_HASH" "$NGCLIENT_NPM_DEPS_HASH"

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
