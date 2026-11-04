#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix coreutils

set -eu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCES_FILE="$SCRIPT_DIR/sources.json"

if [[ $# -ge 1 ]]; then
  version="$1"
else
  version=$(curl -A "Mozilla/5.0" -s https://www.charlesproxy.com/download/ | sed -n 's/.*Version \([0-9.]*\).*/\1/p' | head -n1)
fi

current_version=$(jq -r '.charles5.version' "$SOURCES_FILE" 2>/dev/null || echo "")

if [[ "$current_version" == "$version" && $# -eq 0 ]]; then
  echo "Charles 5 is already up to date: $version"
  exit 0
fi

echo "Updating Charles 5 from $current_version to $version..."

linux_x86_url="https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}_x86_64.tar.gz"
linux_arm_url="https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}_aarch64.tar.gz"
darwin_url="https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.dmg"

echo "Prefetching x86_64-linux..."
linux_x86_hash=$(nix store prefetch-file --json "$linux_x86_url" | jq -r .hash)

echo "Prefetching aarch64-linux..."
linux_arm_hash=$(nix store prefetch-file --json "$linux_arm_url" | jq -r .hash)

echo "Prefetching darwin (x86_64 / aarch64)..."
darwin_hash=$(nix store prefetch-file --json "$darwin_url" | jq -r .hash)

tmp_file=$(mktemp)
jq \
  --arg version "$version" \
  --arg lx_url "$linux_x86_url" --arg lx_hash "$linux_x86_hash" \
  --arg la_url "$linux_arm_url" --arg la_hash "$linux_arm_hash" \
  --arg d_url "$darwin_url" --arg d_hash "$darwin_hash" \
  '.charles5 = {
    version: $version,
    sources: {
      "x86_64-linux": { url: $lx_url, hash: $lx_hash },
      "aarch64-linux": { url: $la_url, hash: $la_hash },
      "x86_64-darwin": { url: $d_url, hash: $d_hash },
      "aarch64-darwin": { url: $d_url, hash: $d_hash }
    }
  }' "$SOURCES_FILE" > "$tmp_file"

mv "$tmp_file" "$SOURCES_FILE"

echo "Updated $SOURCES_FILE (charles5: $version) successfully."
