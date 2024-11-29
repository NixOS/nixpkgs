#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq

set -euo pipefail

rawVersion="$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -s "https://api.github.com/repos/KhronosGroup/VK-GL-CTS/releases" | jq -r  'map(select(.tag_name | startswith("vulkan-cts-"))) | .[0].tag_name')"
basedir="$(git rev-parse --show-toplevel)"

cd "$basedir"
# Strip prefix
version="$(echo "$rawVersion" | sed 's/vulkan-cts-//')"
update-source-version vulkan-cts "$version"

# Update imported sources
tmpDir="$(mktemp -d)"
trap "rm -rf $tmpDir" EXIT

curl -s "https://raw.githubusercontent.com/KhronosGroup/VK-GL-CTS/$rawVersion/external/fetch_sources.py" -o "$tmpDir/fetch_sources.py"
sed -i '/from ctsbuild.common import/d' "$tmpDir/fetch_sources.py"
cd "$(dirname "$0")"
PYTHONPATH="$tmpDir/" ./vk-cts-sources.py
