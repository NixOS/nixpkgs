#!/usr/bin/env nix
#!nix shell --ignore-environment .#cacert .#curl .#bash .#jq .#coreutils .#git --command bash

set -euo pipefail

base_dir="$(git rev-parse --show-toplevel)"/pkgs/by-name/cl/claude-code
base_url="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"

current_version="$(jq ".version" "$base_dir"/manifest.json || echo "<failed to parse>")"
latest_version="$(curl -fsSL "$base_url/latest")"

if [ "$current_version" == "$latest_version" ]; then
  echo "claude-code/update.sh: current version $current_version matches latest version. skipping updates" 2>&1
  exit 0
fi

curl -fsSL "$base_url/$latest_version/manifest.json" --output "$base_dir"/manifest.json
echo "claude-code/update.sh: found version $latest_version that's different from current $current_version. updating..." 2>&1
