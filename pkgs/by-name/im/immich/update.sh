#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq prefetch-npm-deps nix-prefetch-github coreutils ripgrep

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

old_version=$(jq -r ".version" sources.json || echo -n "0.0.1")
version=$(curl -s "https://api.github.com/repos/immich-app/immich/releases/latest" | jq -r ".tag_name")
version="${version#v}"

echo "Updating to $version"

if [[ "$old_version" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

echo "Fetching src"
src_hash=$(nix-prefetch-github immich-app immich --rev "v${version}" | jq -r .hash)
upstream_src="https://raw.githubusercontent.com/immich-app/immich/v$version"

sources_tmp="$(mktemp)"
cat <<EOF > "$sources_tmp"
{
  "version": "$version",
  "hash": "$src_hash",
  "components": {}
}
EOF

lock=$(mktemp)
for npm_component in cli server web "open-api/typescript-sdk"; do
    echo "fetching $npm_component"
    curl -s -o "$lock" "$upstream_src/$npm_component/package-lock.json"
    hash=$(prefetch-npm-deps "$lock")
    echo "$(jq --arg npm_component "$npm_component" \
      --arg hash "$hash" \
      --arg version "$(jq -r '.version' <"$lock")" \
      '.components += {($npm_component): {npmDepsHash: $hash, version: $version}}' \
      "$sources_tmp")" > "$sources_tmp"
done
rm "$lock"

url="http://download.geonames.org/export/dump"
curl -s "http://web.archive.org/save/$url/cities500.zip"
curl -s "http://web.archive.org/save/$url/admin1CodesASCII.txt"
curl -s "http://web.archive.org/save/$url/admin1Codes.txt"
timestamp=$(curl -s \
    "http://archive.org/wayback/available?url=$url/cities500.zip" \
    | jq -r ".archived_snapshots.closest.timestamp")
echo "$(jq --arg timestamp "$timestamp" --arg hash "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" \
    '.components += {geonames: {timestamp: $timestamp, hash: $hash}}' \
    "$sources_tmp")" > "$sources_tmp"

cp "$sources_tmp" sources.json
set +o pipefail
output="$(nix-build ../../../.. -A immich.geodata 2>&1 || true)"
set -o pipefail
hash=$(echo "$output" | rg 'got:\s+(sha256-.*)$' -or '$1')
echo "$(jq --arg hash "$hash" '.components.geonames.hash = $hash' "$sources_tmp")" > "$sources_tmp"

mv "$sources_tmp" sources.json
