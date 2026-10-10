#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl gnused gnutar jq nodejs nix
# shellcheck shell=bash

set -eu -o pipefail

echo "zod: checking pin against context-mode's package.json"

PACKAGE_DIR=$(dirname "$(readlink --canonicalize-existing "${BASH_SOURCE[0]}")")
OUTPUT_FILE="$PACKAGE_DIR/package.nix"

CM_VERSION=$(grep -m1 '^  version = "' "$OUTPUT_FILE" | sed -E 's/.*"(.*)".*/\1/')
ZOD_RANGE=$(
  curl --silent --fail --location \
    "https://registry.npmjs.org/context-mode/-/context-mode-$CM_VERSION.tgz" |
    tar -xzO package/package.json |
    jq --raw-output '.dependencies.zod'
)
NEW_VERSION=$(npm view "zod@$ZOD_RANGE" version --json | jq --raw-output '.[-1]')

CURRENT_VERSION=$(grep -m1 'zod-.*\.tgz' "$OUTPUT_FILE" | sed -E 's/.*zod-(.*)\.tgz.*/\1/')

if [ "$CURRENT_VERSION" == "$NEW_VERSION" ]; then
  echo "zod: no update needed, $CURRENT_VERSION already satisfies $ZOD_RANGE"
  exit 0
fi

echo "zod: $CURRENT_VERSION -> $NEW_VERSION (satisfies $ZOD_RANGE)"

NEW_HASH=$(nix hash convert --hash-algo sha256 --to sri "$(
  nix-prefetch-url --type sha256 "https://registry.npmjs.org/zod/-/zod-$NEW_VERSION.tgz"
)")

sed -i "s#zod-$CURRENT_VERSION\.tgz#zod-$NEW_VERSION.tgz#" "$OUTPUT_FILE"
# Only the hash line following the (now-rewritten) zod URL, not context-mode's src hash above it.
sed -i "/zod-$NEW_VERSION\.tgz/,/hash = \"sha256-/{s#hash = \"sha256-[^\"]*\";#hash = \"$NEW_HASH\";#}" "$OUTPUT_FILE"

echo "zod: UPDATE DONE"
