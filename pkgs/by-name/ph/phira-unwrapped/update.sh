#!/usr/bin/env nix-shell
#!nix-shell -p nix-update nix gnused -i bash

set -euo pipefail

old_version="$(nix-instantiate --eval --raw -A phira-unwrapped.version)"
nix-update phira-unwrapped
version="$(nix-instantiate --eval --raw -A phira-unwrapped.version)"
if [[ "$old_version" == "$version" ]]; then
  exit 0
fi

file="$(nix-instantiate --eval --raw -A phira.meta.position | cut -d : -f 1)"
hash="$(nix-prefetch-url --unpack "https://github.com/TeamFlos/phira/releases/download/v$version/Phira-windows-x86_64-v$version.zip")"
hash="$(nix-hash --to-sri --type sha256 "$hash")"
sed -i "s|hash = \".*\";|hash = \"$hash\";|" "$file"
