#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix wget prefetch-yarn-deps nix-prefetch-github jq

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for the element packages."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version="$1"

set -euo pipefail

if [ -z "$version" ]; then
  version="$(wget -q -O- "https://api.github.com/repos/element-hq/element-desktop/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

# strip leading "v"
version="${version#v}"

# Element Web
web_src="https://raw.githubusercontent.com/element-hq/element-web/v$version"
web_src_hash=$(nix-prefetch-github element-hq element-web --rev v${version} | jq -r .hash)

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

web_tmpdir=$(mktemp -d)
trap 'rm -rf "$web_tmpdir"' EXIT

pushd $web_tmpdir
wget -q "$web_src/yarn.lock"
web_yarn_hash=$(prefetch-yarn-deps yarn.lock)
popd

# Element Desktop
desktop_src="https://raw.githubusercontent.com/element-hq/element-desktop/v$version"
desktop_src_hash=$(nix-prefetch-github element-hq element-desktop --rev v${version} | jq -r .hash)

desktop_tmpdir=$(mktemp -d)
trap 'rm -rf "$desktop_tmpdir"' EXIT

pushd $desktop_tmpdir
wget -q "$desktop_src/yarn.lock"
desktop_yarn_hash=$(prefetch-yarn-deps yarn.lock)
popd

cat > ../element-web-unwrapped/element-web-pin.nix << EOF
{
  "version" = "$version";
  "hashes" = {
    "webSrcHash" = "$web_src_hash";
    "webYarnHash" = "$web_yarn_hash";
  };
}
EOF

cat > element-desktop-pin.nix << EOF
{
  "version" = "$version";
  "hashes" = {
    "desktopSrcHash" = "$desktop_src_hash";
    "desktopYarnHash" = "$desktop_yarn_hash";
  };
}
EOF
