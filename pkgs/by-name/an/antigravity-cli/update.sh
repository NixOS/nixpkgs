#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq nix

set -euo pipefail

sourcesFile=pkgs/by-name/an/antigravity-cli/sources.json
baseUrl=https://storage.googleapis.com/antigravity-public/antigravity-cli

currentVersion=$(jq -r .version "$sourcesFile")
latestVersion=$(curl -sSfL "$baseUrl/latest")

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

manifest=$(curl -sSfL "$baseUrl/$latestVersion/manifest.json")

declare -A platforms=(
    [x86_64-linux.glibc]=linux-x64
    [x86_64-linux.musl]=linux-x64-musl
    [aarch64-linux.glibc]=linux-arm
    [aarch64-linux.musl]=linux-arm-musl
    [aarch64-darwin.libSystem]=darwin-arm
)

sources=$(jq -n --arg version "$latestVersion" '{version: $version, platforms: {}}')

for platform in "${!platforms[@]}"; do
    entry=$(jq -e --arg p "${platforms[$platform]}" '.platforms[$p]' <<<"$manifest")
    url=$(jq -r .url <<<"$entry")
    hash=$(nix --extra-experimental-features nix-command hash convert \
        --hash-algo sha512 --to sri "$(jq -r .sha512 <<<"$entry")")
    sources=$(jq --arg system "${platform%.*}" --arg libc "${platform#*.}" \
        --arg url "$url" --arg hash "$hash" \
        '.platforms[$system][$libc] = {url: $url, hash: $hash}' <<<"$sources")
done

jq -S . <<<"$sources" >"$sourcesFile"
