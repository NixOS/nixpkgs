#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gitMinimal gawk nix nix-update
# shellcheck shell=bash

# Usage: update-release.sh VERSION
#
# Points skippy-native-runtime's `release` at MeshLLM VERSION and the llama.cpp
# release (bNNNNN tag) that VERSION pins, then lets nix-update refresh the
# source hashes and the cargo vendor hash (shared with mesh-llm). Run from the
# nixpkgs root.

set -euo pipefail

version="$1"
attr="skippy-native-runtime"
file="$(dirname "${BASH_SOURCE[0]}")/package.nix"
repo="Mesh-LLM/mesh-llm"

value() {
  nix-instantiate --eval -E "with import ./. { }; $attr.$1" | tr -d '"'
}

replace() {
  if [[ "$(grep -cF "\"$1\"" "$file")" != 1 ]]; then
    echo "expected \"$1\" exactly once in $file" >&2
    exit 1
  fi
  sed -i "s|\"$1\"|\"$2\"|" "$file"
}

old_version="$(value version)"
if [[ "$version" == "$old_version" ]]; then
  echo "$attr already uses MeshLLM $version"
  exit 0
fi

llama_rev="$(curl -sSfL "https://raw.githubusercontent.com/$repo/v$version/skippy/llama_cpp/upstream.txt" | tr -d '[:space:]')" || true
if [[ -z "$llama_rev" ]]; then
  echo "MeshLLM $version has no llama.cpp upstream.txt" >&2
  exit 1
fi
# llama.cpp reports its release number (the bNNNNN tag), which the source tarball does not carry.
llama_build="$(git ls-remote --tags https://github.com/ggml-org/llama.cpp 'refs/tags/b*' |
  awk -v rev="$llama_rev" '$1 == rev && !found { sub("refs/tags/b", "", $2); print $2; found = 1 }')"
if [[ -z "$llama_build" ]]; then
  echo "no llama.cpp release tag points at $llama_rev" >&2
  exit 1
fi

replace "$(value llamaCppBuild)" "$llama_build"
replace "$old_version" "$version"
nix-update "$attr" --version skip --override-filename "$file" --subpackage meshLlmSrc --subpackage automation
