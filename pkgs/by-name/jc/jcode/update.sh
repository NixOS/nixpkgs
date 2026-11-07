#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused coreutils nurl
# shellcheck shell=bash

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

fetch_hash() {
  VER="$1"
  ASSET="$2"
  URL="https://github.com/1jehuang/jcode/releases/download/v${VER}/${ASSET}"
  nurl --hash --expr "(import <nixpkgs> { }).fetchurl { url = \"$URL\"; }"
}

# Latest non-prerelease release tag.
VERSION="$(curl -fsSL https://api.github.com/repos/1jehuang/jcode/releases/latest \
  | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p' | head -n1)"
if [ -z "$VERSION" ]; then
  echo "ERROR: failed to determine the latest jcode version"
  exit 1
fi

echo "Updating jcode to ${VERSION}"

X86_64_LINUX="$(fetch_hash "$VERSION" "jcode-linux-x86_64.tar.gz")"
AARCH64_LINUX="$(fetch_hash "$VERSION" "jcode-linux-aarch64.tar.gz")"
X86_64_DARWIN="$(fetch_hash "$VERSION" "jcode-macos-x86_64.tar.gz")"
AARCH64_DARWIN="$(fetch_hash "$VERSION" "jcode-macos-aarch64.tar.gz")"

# Replace the version and the per-platform hashes, then verify that every
# replacement actually took: `sed -i` exits successfully even when it does
# not match anything, which would silently leave a stale package.nix behind.
replace() {
  PATTERN="$1"
  REPLACEMENT="$2"
  DESCRIPTION="$3"

  BEFORE="$(cat "$NIX_DRV")"

  # The value may already be up to date, in which case the file legitimately
  # does not change. Otherwise the substitution must have matched.
  if ! printf '%s\n' "$BEFORE" | grep -qF "$REPLACEMENT"; then
    sed -i "$PATTERN" "$NIX_DRV"

    if [ "$(cat "$NIX_DRV")" = "$BEFORE" ]; then
      echo "ERROR: failed to update the ${DESCRIPTION} in $NIX_DRV" >&2
      echo "       the expected line was not found; the package file may need manual fixing" >&2
      exit 1
    fi
  fi

  if ! grep -qF "$REPLACEMENT" "$NIX_DRV"; then
    echo "ERROR: failed to update the ${DESCRIPTION} in $NIX_DRV" >&2
    echo "       the expected text was not found; the package file may need manual fixing" >&2
    exit 1
  fi
}

replace 's|^  version = ".*";$|  version = "'"${VERSION}"'";|' \
  "version = \"${VERSION}\"" \
  "version"

replace_sha() {
  SYSTEM="$1"
  SHA="$2"
  replace "s|^\(    ${SYSTEM} = \)\"sha256-.*\";\$|\1\"${SHA}\";|" \
    "${SHA}" \
    "${SYSTEM} hash"
}

replace_sha "x86_64-linux" "$X86_64_LINUX"
replace_sha "aarch64-linux" "$AARCH64_LINUX"
replace_sha "x86_64-darwin" "$X86_64_DARWIN"
replace_sha "aarch64-darwin" "$AARCH64_DARWIN"

echo "Done."
