#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl nix gnused
set -euo pipefail

nix_file=$(nix-instantiate --eval -A fire-alpaca.meta.position 2>/dev/null |
  sed -re 's/^"(.*):[0-9]+"$/\1/')

base_url=https://firealpaca.com/download
archive_url=https://web.archive.org/save

# Version is read from the filename that each download is served under, so
# that it always describes the binaries that get pinned.
download_version() {
  curl -sfI "$base_url"/"$1" |
    sed -nEe 's/^content-disposition:.*filename="?FireAlpaca[^0-9]*([0-9]+(\.[0-9]+)+).*/\1/Ip'
}

version=$(download_version linux)
mac_version=$(download_version mac)
if [[ -z "$version" || "$version" != "$mac_version" ]]; then
  printf 'unexpected versions: linux %s, mac %s\n' "$version" "$mac_version" >&2
  exit 1
fi

old_version=$(nix-instantiate --eval --raw -A fire-alpaca.version)
if [[ "$version" == "$old_version" ]]; then
  printf 'fire-alpaca is already at %s\n' "$version" >&2
  exit 0
fi

# Each download is archived separately, because a snapshot timestamp that has
# no capture of a URL redirects to the nearest, possibly outdated, capture.
# Both downloads are verified before the file is edited, so that a failure
# leaves no partial update behind.
declare -A archived_urls sris
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
  archived_urls[$suffix]=$archived_url
  sris[$suffix]=$(nix-hash --type sha256 --to-sri "$hash")
done

for suffix in linux mac; do
  sed -i \
    -e '\|url = ".*/download/'"$suffix"'";|{s|url = "[^"]*"|url = "'"${archived_urls[$suffix]}"'"|;n;s|hash = "[^"]*"|hash = "'"${sris[$suffix]}"'"|;}' \
    "$nix_file"
done

sed -i "s/version = \"[0-9.]*\";/version = \"$version\";/" "$nix_file"
