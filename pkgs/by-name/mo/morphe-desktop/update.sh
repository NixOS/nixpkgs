#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils jdk gnused curl nix jq unzip common-updater-scripts

# This script is written by Gemini 3.5 Flash-Lite and edited/verified by human.

set -euo pipefail

REPO="MorpheApp/morphe-desktop"
echo "Checking latest release for $REPO..."

latest_release="$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sf "https://api.github.com/repos/$REPO/releases/latest")"
version="$(echo "$latest_release" | jq -r '.tag_name // .name')"
clean_version="${version#v}"

echo "Latest upstream version: $clean_version"

update-source-version morphe-desktop "$clean_version"

jar_url="$(echo "$latest_release" | jq -r '.assets[]? | select(.name | endswith(".jar")) | .browser_download_url' | head -n 1)"

if [ -z "$jar_url" ] || [ "$jar_url" == "null" ]; then
  jar_url="https://github.com/$REPO/releases/download/$version/morphe.jar"
fi

echo "Downloading release jar from $jar_url..."
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

curl -sL "$jar_url" -o "$tmp_dir/app.jar"

echo "Extracting BootstrapConstants.class..."
unzip -q "$tmp_dir/app.jar" "app/morphe/engine/BootstrapConstants.class" -d "$tmp_dir"

CLASS_FILE="$tmp_dir/app/morphe/engine/BootstrapConstants.class"
if [ ! -f "$CLASS_FILE" ]; then
  echo "Error: BootstrapConstants.class not found in jar." >&2
  exit 1
fi

extract_version() {
  local field_name="$1"
  javap -constants "$CLASS_FILE" | grep "$field_name" | sed -E 's/.*"([^"]+)".*/\1/'
}

SKIKO_VERSION=$(extract_version "SKIKO_VERSION")
JNA_VERSION=$(extract_version "JNA_VERSION")
OSHI_VERSION=$(extract_version "OSHI_VERSION")

TARGETS=(
  "linux-x64:x86_64-linux"
  "linux-arm64:aarch64-linux"
  "macos-x64:x86_64-darwin"
  "macos-arm64:aarch64-darwin"
)

# Fetch hashes for platform-neutral dependencies
SKIKO_AWT_URL="https://repo1.maven.org/maven2/org/jetbrains/skiko/skiko-awt/$SKIKO_VERSION/skiko-awt-$SKIKO_VERSION.jar"
JNA_URL="https://repo1.maven.org/maven2/net/java/dev/jna/jna/$JNA_VERSION/jna-$JNA_VERSION.jar"
JNA_PLATFORM_URL="https://repo1.maven.org/maven2/net/java/dev/jna/jna-platform/$JNA_VERSION/jna-platform-$JNA_VERSION.jar"
OSHI_CORE_URL="https://repo1.maven.org/maven2/com/github/oshi/oshi-core/$OSHI_VERSION/oshi-core-$OSHI_VERSION.jar"
OSHI_COMMON_URL="https://repo1.maven.org/maven2/com/github/oshi/oshi-common/$OSHI_VERSION/oshi-common-$OSHI_VERSION.jar"

SKIKO_AWT_HASH=$(nix-prefetch-url --type sha256 "$SKIKO_AWT_URL")
JNA_HASH=$(nix-prefetch-url --type sha256 "$JNA_URL")
JNA_PLATFORM_HASH=$(nix-prefetch-url --type sha256 "$JNA_PLATFORM_URL")
OSHI_CORE_HASH=$(nix-prefetch-url --type sha256 "$OSHI_CORE_URL")
OSHI_COMMON_HASH=$(nix-prefetch-url --type sha256 "$OSHI_COMMON_URL")

# Build per-system JSON structures containing both neutral and runtime dependencies
SYSTEMS_JSON="{}"
for pair in "${TARGETS[@]}"; do
  skiko_target="${pair%%:*}"
  nix_system="${pair##*:}"

  skiko_runtime_url="https://repo1.maven.org/maven2/org/jetbrains/skiko/skiko-awt-runtime-$skiko_target/$SKIKO_VERSION/skiko-awt-runtime-$skiko_target-$SKIKO_VERSION.jar"
  skiko_runtime_hash=$(nix-prefetch-url --type sha256 "$skiko_runtime_url")

  system_deps_json=$(jq -n \
    --arg sa_url "$SKIKO_AWT_URL" --arg sa_hash "$SKIKO_AWT_HASH" \
    --arg j_url "$JNA_URL" --arg j_hash "$JNA_HASH" \
    --arg jp_url "$JNA_PLATFORM_URL" --arg jp_hash "$JNA_PLATFORM_HASH" \
    --arg oc_url "$OSHI_CORE_URL" --arg oc_hash "$OSHI_CORE_HASH" \
    --arg ocm_url "$OSHI_COMMON_URL" --arg ocm_hash "$OSHI_COMMON_HASH" \
    --arg sr_url "$skiko_runtime_url" --arg sr_hash "$skiko_runtime_hash" \
    '{
      "skiko-awt": { "url": $sa_url, "sha256": $sa_hash },
      "jna": { "url": $j_url, "sha256": $j_hash },
      "jna-platform": { "url": $jp_url, "sha256": $jp_hash },
      "oshi-core": { "url": $oc_url, "sha256": $oc_hash },
      "oshi-common": { "url": $ocm_url, "sha256": $ocm_hash },
      "skiko-awt-runtime": { "url": $sr_url, "sha256": $sr_hash }
    }')

  SYSTEMS_JSON=$(echo "$SYSTEMS_JSON" | jq --arg sys "$nix_system" --argjson deps "$system_deps_json" \
    '. + {($sys): $deps}')
done

jq -n \
  --arg app_ver "$clean_version" \
  --argjson systems "$SYSTEMS_JSON" \
  '{
  app_version: $app_ver
} + $systems' >./pkgs/by-name/mo/morphe-desktop/deps.json

echo "Successfully updated version to $clean_version and generated deps.json!"
