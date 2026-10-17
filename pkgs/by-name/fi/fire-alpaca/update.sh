#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl nix gnused
set -euo pipefail

nix_file=$(nix-instantiate --eval -A fire-alpaca.meta.position 2>/dev/null |
  sed -re 's/^"(.*):[0-9]+"$/\1/')

version=$(
  curl -sfL "https://firealpaca.com/download/" |
    grep -oP 'FireAlpaca\s+\K\d+\.\d+\.\d+(?=\s+Download)' |
    head -1
)

base_url=https://firealpaca.com/download
archive_url=https://web.archive.org/save

# Each download is archived separately, because a snapshot timestamp that has
# no capture of a URL redirects to the nearest, possibly outdated, capture.
for suffix in linux mac; do
  live_url="$base_url"/"$suffix"

  archived_url=$(
    curl -sI -L -o /dev/null -w '%{url_effective}' --max-time 300 \
      "$archive_url"/"$live_url" 2>/dev/null || true
  )
  if [[ "$archived_url" != https://web.archive.org/web/[0-9]*/"$live_url" ]]; then
    printf 'web.archive.org/save failed for %s\n' "$live_url" >&2
    exit 1
  fi

  hash=$(nix-prefetch-url "$archived_url")
  live_hash=$(nix-prefetch-url "$live_url")
  if [[ "$hash" != "$live_hash" ]]; then
    printf '%s does not match %s\n' "$archived_url" "$live_url" >&2
    exit 1
  fi
  sri=$(nix-hash --type sha256 --to-sri "$hash")

  sed -i \
    -e '\|url = ".*/download/'"$suffix"'";|{s|url = "[^"]*"|url = "'"$archived_url"'"|;n;s|hash = "[^"]*"|hash = "'"$sri"'"|;}' \
    "$nix_file"
done

sed -i "s/version = \"[0-9.]*\";/version = \"$version\";/" "$nix_file"
