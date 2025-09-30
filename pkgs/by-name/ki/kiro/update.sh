#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq
# shellcheck shell=bash

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PACKAGE_NIX="${SCRIPT_DIR}/package.nix"
SOURCES_JSON="${SCRIPT_DIR}/sources.json"

# Platform configuration
declare -A PLATFORM_URLS=(
    ["x86_64-linux"]="https://prod.download.desktop.kiro.dev/stable/metadata-linux-x64-stable.json"
    ["x86_64-darwin"]="https://prod.download.desktop.kiro.dev/stable/metadata-dmg-darwin-x64-stable.json"
    ["aarch64-darwin"]="https://prod.download.desktop.kiro.dev/stable/metadata-dmg-darwin-arm64-stable.json"
)

# Data storage
declare -A platform_versions
declare -A platform_urls
declare -A platform_hashes

# Error handling
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Script execution starts here
echo "Starting Kiro update process..."

# Fetch metadata for all platforms
echo "Fetching platform information..."
for platform in "${!PLATFORM_URLS[@]}"; do
    url="${PLATFORM_URLS[$platform]}"
    echo "Fetching metadata for $platform..."

    if ! response=$(curl -fsSL "$url"); then
        error_exit "Failed to fetch metadata for $platform from $url"
    fi

    # Extract file URL and version from metadata
    file_url=$(echo "$response" | jq -r '
        .releases[0].updateTo
        | select(.url | test("\\.(tar|dmg)(\\.|$)"))
        | .url' | head -1)

    if [[ -z "$file_url" || "$file_url" == "null" ]]; then
        error_exit "Could not find a valid file URL for $platform in metadata"
    fi

    version=$(echo "$response" | jq -r '.currentRelease')
    if [[ -z "$version" || "$version" == "null" ]]; then
        error_exit "Could not extract version for $platform from metadata"
    fi

    platform_versions["$platform"]="$version"
    platform_urls["$platform"]="$file_url"
done

# Determine the maximum version
max_version=""
for platform in "${!platform_versions[@]}"; do
    version="${platform_versions[$platform]}"
    if [[ -z "$max_version" ]] || [[ "$version" > "$max_version" ]]; then
        max_version="$version"
    fi
done
echo "Latest version across all platforms: $max_version"

# Check if update is needed
if [[ ! -f "$PACKAGE_NIX" ]]; then
    error_exit "package.nix not found at $PACKAGE_NIX"
fi
current_version=$(grep -E '^  version = ' "$PACKAGE_NIX" | cut -d'"' -f2)
if [[ -z "$current_version" ]]; then
    error_exit "Could not extract current version from package.nix"
fi
if [[ "$max_version" == "$current_version" ]]; then
    echo "No update needed. Current version is already the latest: $current_version"
    exit 0
fi

echo "Updating to version: $max_version"
echo "Calculating hashes..."
for platform in "${!platform_urls[@]}"; do
    echo "  Calculating hash for $platform..."
    platform_hashes["$platform"]=$(nix hash convert --hash-algo sha256 "$(nix-prefetch-url "${platform_urls[$platform]}")")
done

# Extract vscode version from the Linux tar.gz archive using nix-prefetch-url
archive_path=$(nix-prefetch-url --print-path "${platform_urls["x86_64-linux"]}" | tail -1)
vscodeVersion=$(tar -Oxzf "$archive_path" "Kiro/resources/app/product.json" | jq -r '.vsCodeVersion')
if [[ -z "$vscodeVersion" || "$vscodeVersion" == "null" ]]; then
    error_exit "Could not extract vsCodeVersion from product.json"
fi

# Update package.nix and generate sources.json
echo "Updating package.nix..."
sed -i "s/version = \".*\"/version = \"$max_version\"/" "$PACKAGE_NIX"
sed -i "s/vscodeVersion = \".*\"/vscodeVersion = \"$vscodeVersion\"/" "$PACKAGE_NIX"

echo "Generating sources.json..."
json_content="{}"
for platform in "${!platform_urls[@]}"; do
    json_content=$(echo "$json_content" | jq --arg platform "$platform" \
        --arg url "${platform_urls[$platform]}" \
        --arg hash "${platform_hashes[$platform]}" \
        '. + {($platform): {url: $url, hash: $hash}}')
done
echo "$json_content" >"$SOURCES_JSON"

echo "Successfully updated package.nix to version $max_version"
echo "Hashes calculated and updated:"
for platform in "${!platform_hashes[@]}"; do
    echo "  $platform: ${platform_hashes[$platform]}"
done
