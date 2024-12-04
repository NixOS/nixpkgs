#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq prefetch-npm-deps nix-prefetch-github coreutils

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
mv "$sources_tmp" sources.json
