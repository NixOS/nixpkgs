#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../../ -i bash -p nix wget prefetch-yarn-deps nix-prefetch-github

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for the element packages."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version="$1"

set -euo pipefail

if [ -z "$version" ]; then
  version="$(wget -O- "https://api.github.com/repos/vector-im/element-desktop/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

# strip leading "v"
version="${version#v}"

desktop_src="https://raw.githubusercontent.com/vector-im/element-desktop/v$version"

desktop_src_hash=$(nix-prefetch-github vector-im element-desktop --rev v${version} | jq -r .sha256)
web_hash=$(nix-prefetch-url "https://github.com/vector-im/element-web/releases/download/v$version/element-v$version.tar.gz")

wget "$desktop_src/package.json" -O element-desktop-package.json

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

pushd $tmpdir
wget "$desktop_src/yarn.lock"
desktop_yarn_hash=$(prefetch-yarn-deps yarn.lock)
popd

cat > pin.json << EOF
{
  "version": "$version",
  "desktopSrcHash": "$desktop_src_hash",
  "desktopYarnHash": "$desktop_yarn_hash",
  "webHash": "$web_hash"
}
EOF
