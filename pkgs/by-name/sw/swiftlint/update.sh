#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix

set -euo pipefail

cd "$(dirname "$0")"

old_version=$(jq -r ".version" sources.json)
version=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
  "https://api.github.com/repos/realm/SwiftLint/releases/latest" | jq -r ".tag_name")

if [[ "$old_version" == "$version" ]]; then
    echo "swiftlint is already up to date at $version"
    exit 0
fi

echo "Updating swiftlint from $old_version to $version"

declare -A platforms=(
    [x86_64-linux]="swiftlint_linux_amd64.zip"
    [aarch64-linux]="swiftlint_linux_arm64.zip"
    [x86_64-darwin]="portable_swiftlint.zip"
    [aarch64-darwin]="portable_swiftlint.zip"
)

sources_tmp="$(mktemp)"
jq -n --arg v "$version" '{version: $v, platforms: {}}' > "$sources_tmp"

for platform in "${!platforms[@]}"; do
    filename="${platforms[$platform]}"
    url="https://github.com/realm/SwiftLint/releases/download/${version}/${filename}"
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

echo "Updated swiftlint to $version"
