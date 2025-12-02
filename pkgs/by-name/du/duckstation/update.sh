#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils nix nix-update curl jq
# shellcheck shell=bash

set -euo pipefail
location="$(dirname "${BASH_SOURCE[0]}")"

echo "checking for new tagged release (github:stenzek/duckstation)..."
old_version=$(nix --extra-experimental-features nix-command eval --raw -f . duckstation.src.tag)
new_version=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/stenzek/duckstation/tags?per_page=1" | jq -r '.[0].name')

if [[ $old_version == "$new_version" ]]; then
  echo "'duckstation' is up-to-date ($old_version == $new_version)"
  exit 0
fi

echo "Updating duckstation from $old_version -> $new_version"
nix-update --src-only --version "$new_version" duckstation
duckstation_darwin_hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "https://github.com/stenzek/duckstation/releases/download/${new_version}/duckstation-mac-release.zip")")

echo "Vendor library update..."
duckstation_storepath=$(nix --extra-experimental-features "nix-command flakes" flake prefetch github:stenzek/duckstation/"$new_version" --json | jq -r '.storePath')
pinned_versions=$duckstation_storepath/scripts/deps/versions

echo "Using pinned discord_rpc..."
discord_rpc_rev=$(grep "DISCORD_RPC_COMMIT=" "$pinned_versions" | sed 's|.*=||g')
discord_rpc_hash=$(nix --extra-experimental-features "nix-command flakes" \
  flake prefetch github:stenzek/discord-rpc/"$discord_rpc_rev" --json |
  jq -r '.hash')

echo "Using pinned shaderc..."
shaderc_rev=$(grep "SHADERC_COMMIT=" "$pinned_versions" | sed 's|.*=||g')
shaderc_hash=$(nix --extra-experimental-features "nix-command flakes" flake prefetch github:stenzek/shaderc/"$shaderc_rev" --json | jq -r '.hash')

echo "Fetching latest chtdb commit..."
chtdb_json=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/duckstation/chtdb/commits?per_page=1")
chtdb_rev=$(echo "$chtdb_json" | jq -r '.[0].sha')
chtdb_date=$(echo "$chtdb_json" | jq -r '.[0].commit.author.date')
chtdb_hash=$(nix --extra-experimental-features "nix-command flakes" \
  flake prefetch github:duckstation/chtdb/"$chtdb_rev" --json |
  jq -r '.hash')

echo "Regenerating '""$location""/sources.json'"
JSON=$(
  jq --null-input \
    --arg new_version "${new_version:1}" \
    --arg duckstation_darwin_hash "$duckstation_darwin_hash" \
    --arg discord_rpc_rev "$discord_rpc_rev" \
    --arg discord_rpc_hash "$discord_rpc_hash" \
    --arg shaderc_rev "$shaderc_rev" \
    --arg shaderc_hash "$shaderc_hash" \
    --arg chtdb_rev "$chtdb_rev" \
    --arg chtdb_date "${chtdb_date::10}" \
    --arg chtdb_hash "$chtdb_hash" \
    '{ "duckstation": {
             "version": $new_version,
             "hash_darwin": $duckstation_darwin_hash
           },
           "discord_rpc": {
             "rev": $discord_rpc_rev,
             "hash": $discord_rpc_hash
           },
           "shaderc": {
             "rev": $shaderc_rev,
             "hash": $shaderc_hash
           },
           "chtdb": {
             "date": $chtdb_date,
             "rev": $chtdb_rev,
             "hash": $chtdb_hash
           }
        }'
)

echo "$JSON" | jq >"$location"/sources.json
