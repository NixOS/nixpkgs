#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gitMinimal gawk jq nix
# shellcheck shell=bash

# Usage: update-release.sh FILE RUNTIME VERSION
#
# Points the mesh-llm-native-runtime `release` attrset in FILE at MeshLLM
# VERSION: the MeshLLM source hash and the llama.cpp release (bNNNNN tag)
# that VERSION pins, with its hash. RUNTIME is a Nix expression for the
# runtime built from FILE's release (for example `mesh-llm-native-runtime`),
# used to read the current values, which are replaced verbatim.
# Run from the nixpkgs root.

set -euo pipefail

file="$1"
runtime="$2"
version="$3"
repo="Mesh-LLM/mesh-llm"

github() {
  # shellcheck disable=SC2086
  curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "$@"
}

attr() {
  nix-instantiate --eval -E "with import ./. { }; ($runtime).$1" | tr -d '"'
}

prefetch() {
  nix hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url --unpack "$1" 2>/dev/null)"
}

replace() {
  if [[ "$(grep -cF "\"$1\"" "$file")" != 1 ]]; then
    echo "expected \"$1\" exactly once in $file" >&2
    exit 1
  fi
  sed -i "s|\"$1\"|\"$2\"|" "$file"
}

old_version="$(attr version)"
if [[ "$version" == "$old_version" ]]; then
  echo "$file already uses MeshLLM $version"
  exit 0
fi

# The pin moved from third_party/llama.cpp to skippy/llama_cpp after 0.78.
for pin in third_party/llama.cpp/upstream.txt skippy/llama_cpp/upstream.txt; do
  llama_rev="$(github "https://raw.githubusercontent.com/$repo/v$version/$pin" 2>/dev/null | tr -d '[:space:]')" && break
done
if [[ -z "${llama_rev:-}" ]]; then
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

old_mesh_hash="$(attr meshLlmSrc.outputHash)"
old_llama_hash="$(attr src.outputHash)"
old_llama_build="$(attr llamaCppBuild)"

replace "$old_mesh_hash" "$(prefetch "https://github.com/$repo/archive/refs/tags/v$version.tar.gz")"
replace "$old_llama_hash" "$(prefetch "https://github.com/ggml-org/llama.cpp/archive/refs/tags/b$llama_build.tar.gz")"
replace "$old_llama_build" "$llama_build"
replace "$old_version" "$version"
