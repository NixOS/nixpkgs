#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts gnused nix

set -euo pipefail

attr=$UPDATE_NIX_ATTR_PATH

latest=$(list-git-tags --url=https://repo.dec05eba.com/gpu-screen-recorder | grep -E '^[0-9]+(\.[0-9]+)*$' | sort -V | tail -1)
update-source-version "$attr" "$latest"

src=$(nix-build --no-out-link -A "$attr.src")
file=$(nix-instantiate --eval -A "$attr.meta.position" | sed -E 's/^"(.*):[0-9]+"$/\1/')

pinned=$(nix-instantiate --eval -A "$attr.ffmpeg.version" | sed -E 's/^"([0-9]+).*/\1/')
wanted=$(sed -nE 's/^directory = ffmpeg-([0-9]+).*/\1/p' "$src/subprojects/ffmpeg.wrap")
if [ -z "$wanted" ]; then
  echo "$attr: could not read the ffmpeg version from upstream" >&2
  exit 1
fi
if [ "$pinned" != "$wanted" ]; then
  if ! nix-instantiate --eval -A "ffmpeg_$wanted.version" >/dev/null 2>&1; then
    echo "$attr: upstream uses ffmpeg $wanted, but ffmpeg_$wanted is not in nixpkgs" >&2
    exit 1
  fi
  sed -i "s/\bffmpeg_$pinned\b/ffmpeg_$wanted/g" "$file"
fi

pinned=$(nix-instantiate --eval -A "$attr.nv-codec-headers.version" | tr -d '"')
wanted=$(sed -n 's/^directory = nv-codec-headers-n//p' "$src/subprojects/nv-codec-headers.wrap")
if [ -z "$wanted" ]; then
  echo "$attr: could not read the nv-codec-headers version from upstream" >&2
  exit 1
fi
if [ "$pinned" != "$wanted" ]; then
  update-source-version "$attr.nv-codec-headers" "$wanted" --file="$file"
fi
