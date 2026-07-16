#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl yq
set -eu -o pipefail

target="$(dirname "$(readlink -f "$0")")/package.nix"
host="https://storage.cubelify.com"
metadata=$(curl "$host/overlay/v1/latest-linux.yml")
version=$(echo "$metadata" | yq .version -r | cut -d- -f1)
hash=$(echo "$metadata" | yq .sha512 -r)

sed -i "s@version = .*;@version = \"$version\";@g" "$target"
sed -i "s@hash.* = .*;@hash = \"sha512-$hash\";@g" "$target"
