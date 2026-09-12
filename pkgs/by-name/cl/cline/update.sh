#!/usr/bin/env nix
#!nix shell --ignore-environment .#cacert .#coreutils .#curl .#jq .#nix .#bash --command bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

VERSION="${1:-$(curl -fsSL https://registry.npmjs.org/cline/latest | jq -r .version)}"

echo "Updating cline to ${VERSION}"

platforms=(darwin-arm64 linux-arm64 linux-x64)

entries=""
for platform in "${platforms[@]}"; do
  url="https://registry.npmjs.org/@cline/cli-${platform}/-/cli-${platform}-${VERSION}.tgz"
  echo "Prefetching ${url}" >&2
  hash=$(nix store prefetch-file --json "$url" | jq -r .hash)
  entries=$(jq -n --argjson acc "${entries:-{}}" --arg k "$platform" --arg h "$hash" \
    '$acc + { ($k): { hash: $h } }')
done

jq -n --arg version "$VERSION" --argjson platforms "$entries" \
  '{ version: $version, platforms: $platforms }' > manifest.json

echo "Wrote manifest.json for cline ${VERSION}"
