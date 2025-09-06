#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-github gnused

set -euo pipefail

nix_file="$(dirname "${BASH_SOURCE[@]}")/package.nix"
version=$(curl -s https://api.github.com/repos/RimSort/RimSort/releases/latest | jq -r '.tag_name | sub("^v"; "")')
hash=$(nix-prefetch-github --fetch-submodules --rev v${version} RimSort RimSort | jq '.hash')

sed -i "0,/version =.*/s||version = \"$version\";|" $nix_file
sed -i "0,/hash =.*/s||hash = $hash;|" $nix_file
