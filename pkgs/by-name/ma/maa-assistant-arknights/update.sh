#!/usr/bin/env -S nix shell nixpkgs#nix nixpkgs#curl nixpkgs#jq nixpkgs#nix-prefetch-github --command bash

set -euo pipefail

directory="$(dirname "$0" | xargs realpath)"
repo="MaaAssistantArknights/MaaAssistantArknights"

prefetch_source() {
    local version="$1" hash maa_utils_rev maa_utils_hash
    hash=$(nix-prefetch-github MaaAssistantArknights MaaAssistantArknights --rev "$version" -v | jq -er .hash) || return
    maa_utils_rev=$(curl -fsSL "https://api.github.com/repos/$repo/contents/src/MaaUtils?ref=$version" | jq -er .sha) || return
    maa_utils_hash=$(nix-prefetch-github MaaXYZ MaaUtils --rev "$maa_utils_rev" -v | jq -er .hash) || return

    jq -n --arg version "${version#v}" --arg hash "$hash" \
        --arg rev "$maa_utils_rev" --arg utilsHash "$maa_utils_hash" \
        '{version: $version, hash: $hash, maaUtils: {rev: $rev, hash: $utilsHash}}'
}

version=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | jq -er .tag_name)
pin=$(prefetch_source "$version")
printf '%s\n' "$pin" > "$directory/pin.json"
cat "$directory/pin.json"
