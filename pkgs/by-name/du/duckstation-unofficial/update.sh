#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-github coreutils
# shellcheck shell=bash

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "checking for new tagged release (github:stenzek/duckstation)..."
old_version=$(jq -r '.duckstation.version' ./sources.json)
duckstation_version=$(curl -s "https://api.github.com/repos/stenzek/duckstation/tags?per_page=1" | jq -r '.[0].name')

if [[ "v$old_version" == "$duckstation_version" ]]; then
    echo "'duckstation-unofficial' is up-to-date (v$old_version == $duckstation_version)"
    duckstation_linux_hash=$(jq -r '.duckstation.hash_linux' ./sources.json)
    duckstation_darwin_hash=$(jq -r '.duckstation.hash_darwin' ./sources.json)
else
    echo "'duckstation-unofficial' updating v$old_version → $duckstation_version..."
    duckstation_linux_hash=$(nix-prefetch-github stenzek duckstation --rev "${duckstation_version}" | jq -r '.hash')
    duckstation_darwin_hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "https://github.com/stenzek/duckstation/releases/download/${duckstation_version}/duckstation-mac-release.zip")")
fi

echo "Vendor library update..."

echo "Fetching latest commit (github:stenzek/discord-rpc)"
discord_rpc_json=$(curl -s "https://api.github.com/repos/stenzek/discord-rpc/commits?per_page=1")
discord_rpc_rev=$(echo "$discord_rpc_json" | jq -r '.[0].sha')
discord_rpc_date=$(echo "$discord_rpc_json" | jq -r '.[0].commit.author.date')
discord_rpc_hash=$(nix-prefetch-github stenzek discord-rpc --rev "$discord_rpc_rev" | jq -r '.hash')

echo "Fetching latest commit (github:stenzek/soundtouch)"
soundtouch_json=$(curl -s "https://api.github.com/repos/stenzek/soundtouch/commits?per_page=1")
soundtouch_rev=$(echo "$soundtouch_json" | jq -r '.[0].sha')
soundtouch_date=$(echo "$soundtouch_json" | jq -r '.[0].commit.author.date')
soundtouch_hash=$(nix-prefetch-github stenzek soundtouch --rev "$soundtouch_rev" | jq -r '.hash')

echo "Fetching latest commit (github:stenzek/shaderc)"
shaderc_json=$(curl -s "https://api.github.com/repos/stenzek/shaderc/commits?per_page=1")
shaderc_rev=$(echo "$shaderc_json" | jq -r '.[0].sha')
shaderc_date=$(echo "$shaderc_json" | jq -r '.[0].commit.author.date')
shaderc_hash=$(nix-prefetch-github stenzek shaderc --rev "$shaderc_rev" | jq -r '.hash')

echo "Fetching latest commit (github:duckstation/chtdb)"
chtdb_json=$(curl -s "https://api.github.com/repos/duckstation/chtdb/commits?per_page=1")
chtdb_rev=$(echo "$chtdb_json" | jq -r '.[0].sha')
chtdb_date=$(echo "$chtdb_json" | jq -r '.[0].commit.author.date')
chtdb_hash=$(nix-prefetch-github duckstation chtdb --rev "$chtdb_rev" | jq -r '.hash')

echo "Regenerating 'sources.json'"
JSON=$(
    jq --null-input \
        --arg duckstation_version "${duckstation_version:1}" \
        --arg duckstation_linux_hash "$duckstation_linux_hash" \
        --arg duckstation_darwin_hash "$duckstation_darwin_hash" \
        --arg discord_rpc_rev "$discord_rpc_rev" \
        --arg discord_rpc_date "${discord_rpc_date::10}" \
        --arg discord_rpc_hash "$discord_rpc_hash" \
        --arg soundtouch_rev "$soundtouch_rev" \
        --arg soundtouch_date "${soundtouch_date::10}" \
        --arg soundtouch_hash "$soundtouch_hash" \
        --arg shaderc_rev "$shaderc_rev" \
        --arg shaderc_date "${shaderc_date::10}" \
        --arg shaderc_hash "$shaderc_hash" \
        --arg chtdb_rev "$chtdb_rev" \
        --arg chtdb_date "${chtdb_date::10}" \
        --arg chtdb_hash "$chtdb_hash" \
        '{ "duckstation": {
             "version": $duckstation_version,
             "hash_linux": $duckstation_linux_hash,
             "hash_darwin": $duckstation_darwin_hash
           },
           "discord_rpc": {
             "date": $discord_rpc_date,
             "rev": $discord_rpc_rev,
             "hash": $discord_rpc_hash
           },
           "soundtouch": {
             "date": $soundtouch_date,
             "rev": $soundtouch_rev,
             "hash": $soundtouch_hash
           },
           "shaderc": {
             "date": $shaderc_date,
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

echo "$JSON" | jq >sources.json
