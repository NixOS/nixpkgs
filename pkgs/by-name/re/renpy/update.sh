#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update html-xml-utils curl

set -euo pipefail

attr() {
  nix-instantiate --eval -A renpy.$1 | tr -d '"'
}

old_version="$(attr version)"
nix-update renpy
new_version="$(attr version)"
if [[ "$old_version" == "$new_version" ]]; then
  exit 0
fi

nix_file="$(attr meta.position | cut -d: -f1)"

codename="$(curl -L https://renpy.org/latest.html | hxclean | hxselect -c h1 small)"
sed -E -i "s/(version_name = ).*/\1$codename/" "$nix_file"

old_bin_src_hash="$(attr binSrc.hash)"
new_bin_src_hash="$(nix-hash --type sha256 --to-sri "$(nix-prefetch-url --unpack "$(attr binSrc.url)")")"
sed -i "s|$old_bin_src_hash|$new_bin_src_hash|" "$nix_file"

old_bin_src_arm_hash="$(attr binSrcArm.hash)"
new_bin_src_arm_hash="$(nix-hash --type sha256 --to-sri "$(nix-prefetch-url --unpack "$(attr binSrcArm.url)")")"
sed -i "s|$old_bin_src_arm_hash|$new_bin_src_arm_hash|" "$nix_file"
