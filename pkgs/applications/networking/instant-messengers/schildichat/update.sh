#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../../ -i bash -p nix wget prefetch-yarn-deps nix-prefetch-git jq

if [[ "$#" -gt 2 || "$1" == -* ]]; then
  echo "Regenerates packaging data for the SchildiChat packages."
  echo "Usage: $0 [git revision or tag] [version string override]"
  exit 1
fi

rev="$1"
version="$2"

set -euo pipefail

if [ -z "$rev" ]; then
  rev="$(wget -O- "https://api.github.com/repos/SchildiChat/schildichat-desktop/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

if [ -z "$version" ]; then
  # strip leading "v"
  version="${rev#v}"
fi

src_data=$(nix-prefetch-git https://github.com/SchildiChat/schildichat-desktop --fetch-submodules --rev $rev)
src=$(echo $src_data | jq -r .path)
src_hash=$(echo $src_data | jq -r .sha256)

web_yarn_hash=$(prefetch-yarn-deps $src/element-web/yarn.lock)
desktop_yarn_hash=$(prefetch-yarn-deps $src/element-desktop/yarn.lock)

cat > pin.json << EOF
{
  "version": "$version",
  "rev": "$rev",
  "srcHash": "$src_hash",
  "webYarnHash": "$web_yarn_hash",
  "desktopYarnHash": "$desktop_yarn_hash"
}
EOF
