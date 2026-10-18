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

version_stable=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | jq -er .tag_name)
version_beta=$(curl -fsSL "https://api.github.com/repos/$repo/releases?per_page=1" | jq -er '.[0].tag_name')

stable=$(prefetch_source "$version_stable")
if [[ "$version_beta" == "$version_stable" ]]; then
    beta="$stable"
else
    beta=$(prefetch_source "$version_beta")
fi

jq -n --argjson stable "$stable" --argjson beta "$beta" \
    '{stable: $stable, beta: $beta}' > "$directory/pin.json"
cat "$directory/pin.json"
