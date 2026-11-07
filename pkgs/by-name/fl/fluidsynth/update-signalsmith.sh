#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p coreutils curl gawk gnugrep gnused jq nix

set -euo pipefail

package_file="$(dirname "$0")/package.nix"
version="$(nix eval --raw -f . fluidsynth.version)"

github() {
  curl -fsSL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/$1"
}

# The signalsmith libraries are pinned by FetchContent in the signalsmith-audio-basics submodule
basics_rev=$(github "FluidSynth/fluidsynth/contents/signalsmith-audio-basics?ref=v$version" | jq -er .sha)
deps=$(curl -fsSL "https://raw.githubusercontent.com/Signalsmith-Audio/basics/$basics_rev/CMakeLists.txt" \
  | awk '$1 == "GIT_REPOSITORY" { n = split($2, p, "/"); repo = p[n]; sub(/\.git$/, "", repo) }
         $1 == "GIT_TAG" { print repo, $2 }')

while read -r repo tag; do
  if ! grep -q "repo = \"$repo\";" "$package_file"; then
    echo "error: new signalsmith dependency $repo $tag, add it to $package_file" >&2
    exit 1
  fi

  old_tag=$(sed -n "/repo = \"$repo\";/,/};/ s|.*tag = \"\([^\"]*\)\".*|\1|p" "$package_file")
  if [[ "$old_tag" == "$tag" ]]; then
    continue
  fi

  hash=$(nix-prefetch-url --unpack "https://github.com/Signalsmith-Audio/$repo/archive/refs/tags/$tag.tar.gz")
  sri=$(nix hash convert --hash-algo sha256 --to sri "$hash")

  echo "signalsmith $repo: $old_tag -> $tag"

  sed -i \
    -e "/repo = \"$repo\";/,/};/ s|tag = \"[^\"]*\"|tag = \"$tag\"|" \
    -e "/repo = \"$repo\";/,/};/ s|hash = \"[^\"]*\"|hash = \"$sri\"|" \
    "$package_file"
done <<<"$deps"
