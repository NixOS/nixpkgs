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
timestamp=

for platform in x86_64-linux aarch64-darwin; do
  case "$platform" in
  x86_64-linux) suffix=linux ;;
  aarch64-darwin) suffix=mac ;;
  esac

  live_url="$base_url"/"$suffix"

  archived_url=$(
    curl -sI -L -o /dev/null -w '%{url_effective}' --max-time 120 \
      "$archive_url"/"$live_url" 2>/dev/null || true
  )

  if [[ "$archived_url" == "$archive_url"* ]] || [[ -z "$archived_url" ]]; then
    printf 'web.archive.org/save failed for %s, using live URL\n' "$live_url" >&2
    archived_url="$live_url"
  else
    [[ -z "$timestamp" ]] && timestamp=$(sed -n 's|.*web/\([0-9]*\)/.*|\1|p' <<<"$archived_url")
  fi

  hash=$(nix-prefetch-url "$archived_url" 2>/dev/null || true)
  if [[ -z "$hash" ]]; then
    printf 'nix-prefetch-url failed for %s, trying live URL\n' "$archived_url" >&2
    hash=$(nix-prefetch-url "$live_url" 2>/dev/null || true)
    archived_url=$live_url
  fi
  sri=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$hash")
  [[ -z "$timestamp" ]] && timestamp=$(date -u +%Y%m%d%H%M%S)

  sed -i '/url =.*'"$suffix"'"/{n;s|hash = "[^"]*"|hash = "'"$sri"'"|;}' "$nix_file"
done

sed -i \
  -e "s/version = \"[0-9.]*\";/version = \"$version\";/" \
  -e "s|https://web.archive.org/web/[0-9]*/https://firealpaca.com/download/|https://web.archive.org/web/$timestamp/https://firealpaca.com/download/|" \
  "$nix_file"
