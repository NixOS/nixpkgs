#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix coreutils prefetch-yarn-deps jq curl

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for the element packages."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version="$1"

set -euo pipefail

if [ -z "$version" ]; then
  version="$(curl -fsSL "https://api.github.com/repos/element-hq/element-desktop/releases/latest" | jq -r '.tag_name')"
fi

# strip leading "v"
version="${version#v}"

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

nixflags=(
  --extra-experimental-features
  "nix-command flakes"
)

# HACK: prefetch-yarn-deps hashes may output extra clutter on stdout (!) so
# we'll need to get the last line, last word
fixupHash() {
  local sorta_yarn_hash="$(tail -n1 <<< "$1")"
  local almost_yarn_hash="${sorta_yarn_hash##* }"
  local yarn_hash="$(nix "${nixflags[@]}" hash convert --hash-algo sha256 "$almost_yarn_hash")"

  printf "%s" "$yarn_hash"
}

getHashes() {
  variant="$1"
  output="$2"

  local url="github:element-hq/element-$variant/v$version"
  local src="$(nix "${nixflags[@]}" flake prefetch --json "$url")"
  local src_hash="$(jq -r ".hash" <<< "$src")"
  local src_path="$(jq -r ".storePath" <<< "$src")"
  local yarn_hash="$(fixupHash "$(prefetch-yarn-deps "$src_path/yarn.lock")")"

  cat > "$output" << EOF
{
  "version" = "$version";
  "hashes" = {
    "${variant}SrcHash" = "$src_hash";
    "${variant}YarnHash" = "$yarn_hash";
  };
}
EOF
}

getHashes web ../element-web-unwrapped/element-web-pin.nix
getHashes desktop element-desktop-pin.nix
