#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq yq-go nix coreutils cacert

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SOURCE_JSON="$DIR/sources.json"

MANIFEST_BASE_URL="https://antigravity-hub-auto-updater-974169037036.us-central1.run.app/manifest"
DOWNLOAD_BASE_URL="https://storage.googleapis.com/antigravity-public/antigravity-hub"

# Function to fetch and resolve latest release details for a platform
resolve_platform() {
    local channel_arch="$1"   # e.g., "x64" or "arm64"

    local manifest_url="${MANIFEST_BASE_URL}/latest-${channel_arch}-linux.yml"
    local yaml_data
    if ! yaml_data=$(curl -s --fail "$manifest_url"); then
        echo "Error: Failed to fetch manifest from $manifest_url" >&2
        exit 1
    fi

    local ver
    ver=$(echo "$yaml_data" | yq '. | .version')
    local url
    url=$(echo "$yaml_data" | yq '.files[] | select(.url == "https://*") | .url')
    local exec_id
    exec_id=$(echo "$url" | sed -E 's|.*/[0-9.]+-([0-9]+)/.*|\1|')

    if [[ -z "$ver" || -z "$exec_id" ]]; then
        echo "Error: Failed to parse version or execution ID from $manifest_url" >&2
        exit 1
    fi

    echo "$ver" "$exec_id"
}

# Function to prefetch and calculate sha256 hash in SRI format
prefetch() {
    local url="$1"

    echo "Prefetching $url..." >&2
    nix store prefetch-file --json "$url" | jq -r .hash
}

# Resolve latest versions and execution IDs for both platforms
echo "Checking latest releases..."
read -r x64_VERSION x64_EXEC_ID < <(resolve_platform "x64")
read -r arm64_VERSION arm64_EXEC_ID < <(resolve_platform "arm64")

# Enforce both platforms are on the same version
if [[ "$x64_VERSION" == "$arm64_VERSION" ]]; then
    TARGET_VERSION="$x64_VERSION"
    TARGET_EXEC_ID="$x64_EXEC_ID"
else
    # Find the lower version to ensure both platforms support this release
    TARGET_VERSION=$(echo -e "$x64_VERSION\n$arm64_VERSION" | sort -V | head -n 1)
    if [[ "$TARGET_VERSION" == "$x64_VERSION" ]]; then
        TARGET_EXEC_ID="$x64_EXEC_ID"
    else
        TARGET_EXEC_ID="$arm64_EXEC_ID"
    fi
    echo "Warning: Platform version mismatch detected (x64: $x64_VERSION, arm64: $arm64_VERSION)." >&2
    echo "Enforcing same version across platforms by aligning to the lower version: $TARGET_VERSION" >&2
fi

# Construct target GCS URLs
x64_URL="${DOWNLOAD_BASE_URL}/${TARGET_VERSION}-${TARGET_EXEC_ID}/linux-x64/Antigravity.tar.gz"
arm64_URL="${DOWNLOAD_BASE_URL}/${TARGET_VERSION}-${TARGET_EXEC_ID}/linux-arm/Antigravity.tar.gz"

# Check if we actually need to update
if [[ -f "$SOURCE_JSON" ]]; then
    CURRENT_VERSION=$(jq -r '.version // empty' "$SOURCE_JSON")
    CURRENT_X64_URL=$(jq -r '.sources."x86_64-linux".url // empty' "$SOURCE_JSON")
    CURRENT_ARM_URL=$(jq -r '.sources."aarch64-linux".url // empty' "$SOURCE_JSON")

    if [[ "$CURRENT_X64_URL" == "$x64_URL" && "$CURRENT_ARM_URL" == "$arm64_URL" ]]; then
        echo "Antigravity Hub is already up to date (version: $TARGET_VERSION)"
        exit 0
    fi

    if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
        echo "Version is the same ($TARGET_VERSION), but URLs have changed. Updating to fresh URLs..."
    fi
fi

echo "Updating Antigravity Hub..."
echo "  Target Version: $TARGET_VERSION"
echo "  Target Exec ID: $TARGET_EXEC_ID"
echo "  x64 URL:        $x64_URL"
echo "  arm64 URL:      $arm64_URL"

# Write new sources.json
jq -n \
  --arg ver "$TARGET_VERSION" \
  --arg url_x64 "$x64_URL" \
  --arg hash_x64 "$(prefetch "$x64_URL")" \
  --arg root_x64 "Antigravity-x64" \
  --arg url_arm "$arm64_URL" \
  --arg hash_arm "$(prefetch "$arm64_URL")" \
  --arg root_arm "Antigravity-arm64" \
  '{
    version: $ver,
    sources: {
      "x86_64-linux": { url: $url_x64, sha256: $hash_x64, sourceRoot: $root_x64 },
      "aarch64-linux": { url: $url_arm, sha256: $hash_arm, sourceRoot: $root_arm }
    }
  }' > "$SOURCE_JSON"

echo "Successfully updated sources.json to $TARGET_VERSION."
