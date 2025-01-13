#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p nix jq
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
package=(~/.config/itch/apps/deepdwn/Deepdwn-*.AppImage)

if [ ! -e "${package[0]}" ]; then
  echo "No matching file found.";
  exit 1
fi

hash=$(nix hash file --type sha256 --sri "${package[0]}")
filename=$(basename "${package[0]}")
version="${filename#Deepdwn-}"
version="${version%.AppImage}"

jq -n "{version: \"$version\", hash: \"$hash\"}" > source.json

nix-store --add-fixed sha256 "${package[0]}"
