#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils git gnugrep gnused jq nix-prefetch-github
set -euo pipefail

# Convert upstream tags, that are libunibreak_<major>_<minor>[_<patch>],
# to the normal dotted version scheme

attr="libunibreak"

version=$(
  git ls-remote --tags --refs https://github.com/adah1972/libunibreak |
  cut -f2 \
  | sed 's|refs/tags/||' \
  | grep -E '^libunibreak_[0-9]+(_[0-9]+)*$' \
  | sed -e 's/^libunibreak_//' -e 's/_/./g' \
  | sort -V \
  | tail -n1
)
tag="libunibreak_${version//./_}"

file=$(nix-instantiate --eval --strict -A "$attr.meta.position" | tr -d '"' | cut -d: -f1)

current_version=$(sed -nE 's/^[[:space:]]*version \? "([^"]*)".*/\1/p' "$file")

if [ "$current_version" = "$version" ]; then
  echo "$attr is already at $version"
  exit 0
fi

hash=$(nix-prefetch-github --json --rev "$tag" adah1972 libunibreak | jq -r '.hash')

sed -i -E \
  -e "s|^([[:space:]]*version \? )\"[^\"]*\"|\\1\"$version\"|" \
  -e "s|^([[:space:]]*hash \? )\"[^\"]*\"|\\1\"$hash\"|" \
  "$file"

echo "Updated $attr: $current_version -> $version (tag $tag)"
