#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts jq nix prefetch-yarn-deps

set -eux -o pipefail

latest_version=$(curl -s https://framagit.org/api/v4/projects/48668/repository/tags | jq --raw-output  '.[0].name' | sed 's/^v//')

nixFile=$(nix-instantiate --eval --strict -A "gancio.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')
nixFolder=$(dirname "$nixFile")

curl -o "$nixFolder/package.json" -s "https://framagit.org/les/gancio/-/raw/v$latest_version/package.json"
curl -o "$nixFolder/yarn.lock" -s "https://framagit.org/les/gancio/-/raw/v$latest_version/yarn.lock"

old_yarn_hash=$(nix-instantiate --eval --strict -A "gancio.offlineCache.outputHash" | tr -d '"' | sed -re 's|[+]|\\&|g')
new_yarn_hash=$(nix hash to-sri --type sha256 $(prefetch-yarn-deps "$nixFolder/yarn.lock"))
sed -i "$nixFile" -re "s|\"$old_yarn_hash\"|\"$new_yarn_hash\"|"
rm "$nixFolder/yarn.lock"

update-source-version gancio "$latest_version"
