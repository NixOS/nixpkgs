#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl xmlstarlet

attr=libopenmpt

set -eu -o pipefail

# Get update notifications, remove updates for libopenmpt-modplug, find latest eligible & extract versions
versions="$(
  curl -s 'https://lib.openmpt.org/libopenmpt/feed.xml' |
  xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -m /atom:feed/atom:entry -v atom:title -n |
  grep -v 'libopenmpt-modplug' | head -n1 |
  grep -Eo '([0-9][^,\s]+)' | tr '\n' ' '
)"
echo "Latest $attr versions: $versions"

# Find a version that is > current version and not a rc
# rc's have different download path and a full release will usually follow shortly
currentVersion="$(nix-instantiate --eval -E "with import ./. {}; $attr.version" | tr -d '"')"
echo "Current $attr version: $currentVersion"
for version in $versions; do
  (echo "$version" | grep -q 'rc') && continue
  [ "$version" = "$(printf '%s\n%s' "$version" "$currentVersion" | sort -V | head -n1)" ] && continue

  echo "Updating to $version. Please check if other versions qualify for backport to stable!"
  update-source-version "$attr" "$version"
  exit 0
done

echo "No version eligible for bump."
exit 0
