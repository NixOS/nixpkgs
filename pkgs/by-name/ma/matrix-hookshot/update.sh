#!/usr/bin/env -S nix shell nixpkgs#nix nixpkgs#curl nixpkgs#jq nixpkgs#prefetch-yarn-deps nixpkgs#nix-prefetch-github nixpkgs#nix-prefetch-git --command bash

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for matrix-hookshot."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version="$1"

set -euo pipefail

if [ -z "$version" ]; then
  version="$(curl "https://api.github.com/repos/matrix-org/matrix-hookshot/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

src="https://raw.githubusercontent.com/matrix-org/matrix-hookshot/$version"
src_hash=$(nix-prefetch-github matrix-org matrix-hookshot --rev ${version} | jq -r .hash)

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

pushd $tmpdir
curl -O "$src/yarn.lock"
yarn_hash=$(prefetch-yarn-deps yarn.lock)
popd

curl -O "$src/package.json"
# There is no prefetcher for the cargo hash, but care should still be taken to update it
cat > pin.json << EOF
{
  "version": "$version",
  "srcHash": "$src_hash",
  "yarnHash": "$yarn_hash",
  "cargoHash": "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
}
EOF
