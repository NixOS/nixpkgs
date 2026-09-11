#!/usr/bin/env bash
set -euo pipefail

# If invoked via update.nix with (toString ./.), $1 is the package dir in your git tree.
# Otherwise, fall back to the script's own directory (for direct ./update.sh invocations).
PKG_DIR="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
SOURCES_FILE="${PKG_DIR}/sources.json"
REGISTRY_URL="https://raw.githubusercontent.com/agentclientprotocol/registry/main/antigravity-acp/agent.json"

echo "Fetching agent.json..."
agent_json=$(curl -sSfL "$REGISTRY_URL")
new_version=$(echo "$agent_json" | jq -r '.version')

current_version=""
if [ -f "$SOURCES_FILE" ]; then
  current_version=$(jq -r '.version // empty' "$SOURCES_FILE")
fi

if [ "$new_version" = "$current_version" ]; then
  echo "antigravity-acp is already up to date ($current_version)."
  exit 0
fi

echo "Updating antigravity-acp: ${current_version:-none} -> $new_version"

declare -A PLATFORMS=(
  ["x86_64-linux"]="linux-x86_64"
  ["aarch64-linux"]="linux-aarch64"
  ["aarch64-darwin"]="darwin-aarch64"
)

out_json=$(jq -n --arg v "$new_version" '{version: $v}')

for nix_arch in "${!PLATFORMS[@]}"; do
  reg_arch="${PLATFORMS[$nix_arch]}"
  archive_url=$(echo "$agent_json" | jq -r --arg a "$reg_arch" '.distribution.binary[$a].archive // empty')

  if [ -z "$archive_url" ] || [ "$archive_url" = "null" ]; then
    echo "Warning: no archive found for $reg_arch ($nix_arch)" >&2
    continue
  fi

  echo "Prefetching $nix_arch: $archive_url"
  hash=$(nix store prefetch-file --json "$archive_url" | jq -r '.hash')

  out_json=$(echo "$out_json" | jq \
    --arg arch "$nix_arch" \
    --arg url "$archive_url" \
    --arg hash "$hash" \
    '.[$arch] = { url: $url, hash: $hash }')
done

echo "$out_json" | jq . > "$SOURCES_FILE"
echo "Successfully updated $SOURCES_FILE to $new_version."
