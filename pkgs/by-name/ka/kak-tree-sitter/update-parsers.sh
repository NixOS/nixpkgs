#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash yq nix-prefetch-git

set -eux

SRC="$(nix-build --no-out-link -A kak-tree-sitter-unwrapped.src)"
CONFIG="$SRC/kak-tree-sitter-config/default-config.toml"

tomlq -r '.. | select(objects and (.git | objects)) | "\(.git.url) \(.git.pin)"' "$CONFIG" \
| sort -u \
| while read -r url rev; do
    nix-prefetch-git --no-add-path "$url" "$rev" \
    | jq --arg url "$url" --arg rev "$rev" '{ url: $url, rev: $rev, hash: .hash }'
  done \
| jq -s 'map({key: "\(.url) \(.rev)", value: .hash}) | from_entries' \
> raw_hashes

tomlq --slurpfile hashes raw_hashes '
$hashes[0] as $hashmap
| {
    grammar: .grammar
      | with_entries(select(.value.source != null and .value.source.git != null)
        | .value = .value.source.git
        | .value.hash = $hashmap["\(.value.url) \(.value.pin)"]
      ),
    queries: .language
      | with_entries(select(.value.queries != null and .value.queries.source != null and .value.queries.source.git != null)
        | .value = .value.queries.source.git
        | .value.hash = $hashmap["\(.value.url) \(.value.pin)"]
      )
}' "$CONFIG" >pkgs/by-name/ka/kak-tree-sitter/parsers.json
rm raw_hashes
