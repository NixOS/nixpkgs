#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p jq nix

set -euo pipefail

package_file="$(dirname "$0")/package.nix"
src=$(nix-build -A fluidsynth.src --no-out-link)

awk '$1 == "GIT_REPOSITORY" { n = split($2, p, "/"); repo = p[n]; sub(/\.git$/, "", repo) }
     $1 == "GIT_TAG" { print repo, $2 }' "$src/signalsmith-audio-basics/CMakeLists.txt" |
  while read -r repo tag; do
    if ! grep -q "repo = \"$repo\";" "$package_file"; then
      echo "error: new signalsmith dependency $repo $tag, add it to $package_file" >&2
      exit 1
    fi
    hash=$(nix store prefetch-file --json --unpack "https://github.com/Signalsmith-Audio/$repo/archive/refs/tags/$tag.tar.gz" | jq -r .hash)
    sed -i "/repo = \"$repo\";/,/};/ { s|tag = \"[^\"]*\"|tag = \"$tag\"|; s|hash = \"[^\"]*\"|hash = \"$hash\"|; }" "$package_file"
  done
