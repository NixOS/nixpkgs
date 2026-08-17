#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix

set -euo pipefail

cd "$(dirname "$0")"

channel="ascii-prod"
repo="ariana-dot-dev/agent-server"

old_version=$(jq -r ".version" sources.json)

tag=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
  "https://api.github.com/repos/${repo}/git/refs/tags/box-cli-v" \
  | jq -r --arg channel "$channel" \
    '[.[].ref | select(test($channel)) | ltrimstr("refs/tags/")] | sort_by(split(".")[2] | tonumber) | last')

if [[ -z "$tag" || "$tag" == "null" ]]; then
    echo "No box-cli release found for channel $channel"
    exit 1
fi

version=$(echo "$tag" | sed -n 's/^box-cli-v\([0-9.]*\)-.*/\1/p')

if [[ "$old_version" == "$version" ]]; then
    echo "box-cli is already up to date at $version"
    exit 0
fi

echo "Updating box-cli from $old_version to $version"

declare -A platforms=(
    [x86_64-linux]="box-linux-x64"
    [aarch64-linux]="box-linux-arm64"
    [x86_64-darwin]="box-darwin-x64"
    [aarch64-darwin]="box-darwin-arm64"
)

sources_tmp="$(mktemp)"
jq -n --arg v "$version" --arg t "$tag" '{version: $v, tag: $t, platforms: {}}' > "$sources_tmp"

for platform in "${!platforms[@]}"; do
    filename="${platforms[$platform]}"
    url="https://github.com/${repo}/releases/download/${tag}/${filename}"
    echo "Fetching hash for $platform ($filename)..."
    sha256hash="$(nix-prefetch-url --type sha256 "$url")"
    hash="$(nix hash convert --to sri --hash-algo sha256 "$sha256hash")"
    jq --arg platform "$platform" \
       --arg filename "$filename" \
       --arg hash "$hash" \
       '.platforms += {($platform): {filename: $filename, hash: $hash}}' \
       "$sources_tmp" > "${sources_tmp}.tmp" && mv "${sources_tmp}.tmp" "$sources_tmp"
done

mv "$sources_tmp" sources.json

echo "Updated box-cli to $version (tag: $tag)"
