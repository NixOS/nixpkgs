#!/usr/bin/env bash

model=$1
attr=$UPDATE_NIX_ATTR_PATH
file=$(nix-instantiate --eval --strict -A "$attr.meta.position" | tr -d '"' | cut -d: -f1)

url=$(curl -fsSL "https://www.idprt.com/downloads/$model?type=driver" \
  | grep -oE 'https://[^"]+_linux_driver_v[0-9.]+\.(zip|tar\.gz)' | sort -u | head -n1)
version=$(grep -oE '_v[0-9.]+\.(zip|tar\.gz)$' <<<"$url" | sed -E 's/^_v//; s/\.(zip|tar\.gz)$//')
if [ -z "$url" ] || [ -z "$version" ]; then
  echo "$attr: could not find driver download" >&2
  exit 1
fi

oldVersion=$(nix-instantiate --eval --strict -A "$attr.version" | tr -d '"')
if [ "$version" = "$oldVersion" ]; then
  echo "$attr: already at $version"
  exit 0
fi

hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url --unpack "$url")")
oldUrl=$(nix-instantiate --eval --strict -A "$attr.src.url" | tr -d '"')
oldHash=$(nix-instantiate --eval --strict -A "$attr.src.outputHash" | tr -d '"')

sed -i \
  -e "s|^\(\s*version = \)\"$oldVersion\"|\1\"$version\"|" \
  -e "s|$oldUrl|$url|" \
  -e "s|$oldHash|$hash|" \
  "$file"
