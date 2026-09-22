#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix

set -euo pipefail

cd "$(dirname "$0")"

repo="fayazara/Screendrop"

old_version=$(jq -r ".version" sources.json)

release=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
  "https://api.github.com/repos/${repo}/releases/latest")

tag=$(jq -r ".tag_name" <<< "$release")

if [[ -z "$tag" || "$tag" == "null" ]]; then
    echo "No Screendrop release found"
    exit 1
fi

version="${tag#v}"

if [[ "$old_version" == "$version" ]]; then
    echo "screendrop is already up to date at $version"
    exit 0
fi

echo "Updating screendrop from $old_version to $version"

filename=$(jq -r '.assets[] | select(.name == "Screendrop.dmg") | .name' <<< "$release")

if [[ -z "$filename" || "$filename" == "null" ]]; then
    echo "No Screendrop.dmg release asset found for $tag"
    exit 1
fi

url="https://github.com/${repo}/releases/download/${tag}/${filename}"
sha256hash="$(nix-prefetch-url --type sha256 "$url")"
hash="$(nix hash convert --to sri --hash-algo sha256 "$sha256hash")"

sources_tmp="$(mktemp)"
jq -n --arg v "$version" --arg t "$tag" '{version: $v, tag: $t, platforms: {}}' > "$sources_tmp"

for platform in x86_64-darwin aarch64-darwin; do
    jq --arg platform "$platform" \
       --arg filename "$filename" \
       --arg hash "$hash" \
       '.platforms += {($platform): {filename: $filename, hash: $hash}}' \
       "$sources_tmp" > "${sources_tmp}.tmp" && mv "${sources_tmp}.tmp" "$sources_tmp"
done

mv "$sources_tmp" sources.json

echo "Updated screendrop to $version (tag: $tag)"
