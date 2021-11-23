#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../../ -i bash -p nix wget prefetch-yarn-deps nix-prefetch-git jq
# shellcheck shell=bash

if [[ "$#" -gt 1 || "$1" == -* ]]; then
  echo "Regenerates packaging data for the SchildiChat packages."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version="$1"

set -euo pipefail

if [ -z "$version" ]; then
  version="$(wget -O- "https://api.github.com/repos/SchildiChat/schildichat-desktop/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

# strip leading "v"
version="${version#v}"

src_data=$(nix-prefetch-git https://github.com/SchildiChat/schildichat-desktop --fetch-submodules --rev v${version})
src=$(echo $src_data | jq -r .path)
src_hash=$(echo $src_data | jq -r .sha256)

web_yarn_hash=$(prefetch-yarn-deps $src/element-web/yarn.lock)
desktop_yarn_hash=$(prefetch-yarn-deps $src/element-desktop/yarn.lock)

cat > pin.json << EOF
{
  "version": "$version",
  "srcHash": "$src_hash",
  "webYarnHash": "$web_yarn_hash",
  "desktopYarnHash": "$desktop_yarn_hash"
}
EOF
