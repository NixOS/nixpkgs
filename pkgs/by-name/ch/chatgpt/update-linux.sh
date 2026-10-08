#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl dpkg coreutils common-updater-scripts
#shellcheck shell=bash

set -euo pipefail

URL="https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb"
PACKAGE_NIX="$(dirname "${BASH_SOURCE[0]}")/linux.nix"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading ChatGPT Linux..."

if [[ -n "${CHATGPT_DEB_FILE:-}" ]]; then
  cp -- "$CHATGPT_DEB_FILE" "$TMP_DIR/chatgpt.deb"
else
  curl --fail --location --show-error --silent \
    "$URL" \
    --output "$TMP_DIR/chatgpt.deb"
fi

PACKAGE="$(dpkg-deb --field "$TMP_DIR/chatgpt.deb" Package)"
VERSION="$(dpkg-deb --field "$TMP_DIR/chatgpt.deb" Version)"
ARCH="$(dpkg-deb --field "$TMP_DIR/chatgpt.deb" Architecture)"

if [[ "$PACKAGE" != "chatgpt" || "$ARCH" != "amd64" || -z "$VERSION" ]]; then
  echo "Unexpected Debian package metadata" >&2
  exit 1
fi

HASH="$(nix --extra-experimental-features nix-command hash file \
  --type sha256 "$TMP_DIR/chatgpt.deb")"

echo "Version: $VERSION"
echo "Hash: $HASH"

CURRENT_VERSION="$(nix-instantiate --system x86_64-linux --eval --raw -A chatgpt.version)"
CURRENT_HASH="$(nix-instantiate --system x86_64-linux --eval --raw -A chatgpt.src.drvAttrs.outputHash)"

if [[ "$VERSION" == "$CURRENT_VERSION" && "$HASH" == "$CURRENT_HASH" ]]; then
  echo "ChatGPT Linux is already up to date."
  exit 0
fi

update-source-version \
  chatgpt \
  "$VERSION" \
  "$HASH" \
  --system=x86_64-linux \
  --file="$PACKAGE_NIX" \
  --ignore-same-version
