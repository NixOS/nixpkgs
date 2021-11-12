#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../../../ -i bash -p wget prefetch-yarn-deps yarn nix-prefetch

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for the seshat package."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version="$1"

set -euo pipefail

if [ -z "$version" ]; then
  version="$(wget -O- "https://api.github.com/repos/matrix-org/seshat/tags" | jq -r '.[] | .name' | sort --version-sort | tail -1)"
fi

SRC="https://raw.githubusercontent.com/matrix-org/seshat/$version"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

pushd $tmpdir
wget "$SRC/seshat-node/yarn.lock"
yarn_hash=$(prefetch-yarn-deps yarn.lock)
popd

src_hash=$(nix-prefetch-github matrix-org seshat --rev ${version} | jq -r .sha256)

cat > pin.json << EOF
{
  "version": "$version",
  "srcHash": "$src_hash",
  "yarnHash": "$yarn_hash",
  "cargoHash": "0000000000000000000000000000000000000000000000000000"
}
EOF

cargo_hash=$(nix-prefetch "{ sha256 }: (import ../../../../../.. {}).element-desktop.seshat.cargoDeps")

cat > pin.json << EOF
{
  "version": "$version",
  "srcHash": "$src_hash",
  "yarnHash": "$yarn_hash",
  "cargoHash": "$cargo_hash"
}
EOF

