#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix-prefetch moreutils

set -euo pipefail
cd "$(dirname "$0")"

nixpkgs="$(git rev-parse --show-toplevel)"

oldVersion=$(nix-instantiate --eval -E "(import \"$nixpkgs\" { config = {}; overlays = []; }).cudatext.version" | tr -d '"')
version=$(curl -s https://api.github.com/repos/Alexey-T/CudaText/releases/latest | jq -r '.tag_name')

if [[ $version == $oldVersion ]]; then
  echo "Already at latest version $version"
  exit 0
fi
echo "New version: $version"

url="https://github.com/Alexey-T/CudaText/archive/refs/tags/${version}.tar.gz"
hash=$(nix-prefetch-url --quiet --unpack --type sha256 $url)
sriHash=$(nix hash to-sri --type sha256 $hash)

sed -i "s#version = \".*\"#version = \"$version\"#" default.nix
sed -i "s#hash = \".*\"#hash = \"$sriHash\"#" default.nix

while IFS=$'\t' read repo owner rev; do
  latest=$(curl -s https://api.github.com/repos/${owner}/${repo}/releases/latest | jq -r '.tag_name')
  if [ "$latest" != "$rev" ]; then
    url="https://github.com/${owner}/${repo}/archive/refs/tags/${latest}.tar.gz"
    hash=$(nix-prefetch-url --quiet --unpack --type sha256 $url)
    sriHash=$(nix hash to-sri --type sha256 $hash)
    jq ".\"${repo}\".rev = \"${latest}\" | .\"${repo}\".hash = \"${sriHash}\"" deps.json | sponge deps.json
  fi
done <<< $(jq -r 'to_entries[]|[.key,.value.owner,.value.rev]|@tsv' deps.json)
