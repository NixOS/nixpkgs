#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix nix-update

set -euxo pipefail

nix-update "${UPDATE_NIX_ATTR_PATH}"
nix-update "${UPDATE_NIX_ATTR_PATH}.npmPkg" --version=skip

FILE="$(nix-instantiate --eval -E 'with import ./. {}; (builtins.unsafeGetAttrPos "version" '"${UPDATE_NIX_ATTR_PATH}"').file' | tr -d '"')"

MVNHASH_OLD=$(nix-instantiate --eval . -A "${UPDATE_NIX_ATTR_PATH}.mvnHash" | tr -d '"')
MVNHASH_OLD_ESCAPED=$(echo "${MVNHASH_OLD}" | sed -re 's|[+]|\\&|g')
FAKEHASH=$(nix-instantiate --eval . -A "lib.fakeHash" | tr -d '"')
FAKEHASH_ESCAPED=$(echo "${FAKEHASH}" | sed -re 's|[+]|\\&|g')

sed -E -i "s|${MVNHASH_OLD_ESCAPED}|${FAKEHASH}|g" "${FILE}"

MVNHASH_NEW="$(nix-build . -A "${UPDATE_NIX_ATTR_PATH}" 2>&1 | tail -n10 | grep 'got:' | cut -d: -f2- | xargs echo || true)"

sed -E -i "s|${FAKEHASH_ESCAPED}|${MVNHASH_NEW}|g" "${FILE}"
