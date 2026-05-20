#!/usr/bin/env bash
#
# Antigravity CLI Nix Update Script
# Automatically fetches the latest manifests, extracts versions/hashes, and writes to sources.json.
# Can be run via: nix-shell -p curl jq --run ./update.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCES_JSON="$SCRIPT_DIR/sources.json"

DOWNLOAD_BASE_URL="https://antigravity-cli-auto-updater-974169037036.us-central1.run.app"

# Helper to fetch and parse JSON
fetch_manifest() {
    local platform="$1"
    curl -fsSL "$DOWNLOAD_BASE_URL/manifests/$platform.json"
}

echo "Fetching latest manifests from release repository..."
darwin_amd64=$(fetch_manifest "darwin_amd64")
darwin_arm64=$(fetch_manifest "darwin_arm64")
linux_amd64=$(fetch_manifest "linux_amd64")
linux_arm64=$(fetch_manifest "linux_arm64")

# Extract version
version=$(echo "$darwin_arm64" | jq -r '.version')
echo "✓ Latest version detected: $version"

# Extract URLs and compute standard Nix hashes
darwin_amd64_url=$(echo "$darwin_amd64" | jq -r '.url')
darwin_amd64_hash=$(echo "$darwin_amd64" | jq -r '.sha512')

darwin_arm64_url=$(echo "$darwin_arm64" | jq -r '.url')
darwin_arm64_hash=$(echo "$darwin_arm64" | jq -r '.sha512')

linux_amd64_url=$(echo "$linux_amd64" | jq -r '.url')
linux_amd64_hash=$(echo "$linux_amd64" | jq -r '.sha512')

linux_arm64_url=$(echo "$linux_arm64" | jq -r '.url')
linux_arm64_hash=$(echo "$linux_arm64" | jq -r '.sha512')

# Construct the new sources.json
cat <<EOF > "$SOURCES_JSON"
{
  "version": "$version",
  "sources": {
    "x86_64-darwin": {
      "url": "$darwin_amd64_url",
      "sha512": "$darwin_amd64_hash"
    },
    "aarch64-darwin": {
      "url": "$darwin_arm64_url",
      "sha512": "$darwin_arm64_hash"
    },
    "x86_64-linux": {
      "url": "$linux_amd64_url",
      "sha512": "$linux_amd64_hash"
    },
    "aarch64-linux": {
      "url": "$linux_arm64_url",
      "sha512": "$linux_arm64_hash"
    }
  }
}
EOF

echo "✓ Successfully updated $SOURCES_JSON"
