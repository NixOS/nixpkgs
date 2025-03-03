#!/usr/bin/env -S nix shell nixpkgs#nix nixpkgs#curl nixpkgs#jq nixpkgs#nix-prefetch-github --command bash

set -euo pipefail

directory="$(dirname $0 | xargs realpath)"

version_stable="$(curl "https://api.github.com/repos/MaaAssistantArknights/MaaAssistantArknights/releases/latest" | jq -r '.tag_name')"

hash_stable=$(nix-prefetch-github MaaAssistantArknights MaaAssistantArknights --rev ${version_stable} -v | jq -r .hash)

version_beta="$(curl "https://api.github.com/repos/MaaAssistantArknights/MaaAssistantArknights/releases?per_page=1" | jq -r '.[0].tag_name')"

hash_beta=$(nix-prefetch-github MaaAssistantArknights MaaAssistantArknights --rev ${version_beta} -v | jq -r .hash)

cat > $directory/pin.json << EOF
{
  "stable": {
    "version": "${version_stable#*v}",
    "hash": "$hash_stable"
  },
  "beta": {
    "version": "${version_beta#*v}",
    "hash": "$hash_beta"
  }
}
EOF

cat $directory/pin.json
