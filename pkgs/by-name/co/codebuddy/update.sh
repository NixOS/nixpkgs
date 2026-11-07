#!/usr/bin/env nix
#!nix shell --ignore-environment .#bash .#cacert .#coreutils .#curl .#gnugrep .#jq --command bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

BASE_URL="https://acc-1258344699.cos.accelerate.myqcloud.com/@tencent-ai/codebuddy-code/releases"

# Upstream publishes a plain-text `latest` version and a sha256sums file listing
# every asset, so we record the assets package.nix consumes as a manifest.
version=$(curl -fsSL "$BASE_URL/latest" | tr -d '[:space:]')
checksums=$(curl -fsSL "$BASE_URL/download/$version/checksums.txt")

manifest=$(jq -n --arg version "$version" '{version: $version, assets: {}}')

for target in Linux_x86_64 Linux_arm64 Darwin_x86_64 Darwin_arm64; do
  file="codebuddy-code_${target}.tar.gz"
  sha256=$(grep " $file\$" <<<"$checksums" | cut -d' ' -f1)
  [[ -n $sha256 ]] || {
    echo "error: no checksum for $file in $version" >&2
    exit 1
  }
  manifest=$(jq --arg target "$target" --arg file "$file" --arg sha256 "$sha256" \
    '.assets[$target] = {file: $file, sha256: $sha256}' <<<"$manifest")
done

printf '%s\n' "$manifest" >manifest.json
