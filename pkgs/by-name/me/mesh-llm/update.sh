#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gitMinimal jq nix-update
# shellcheck shell=bash

# Updates mesh-llm and skippy-native-runtime together: the runtime is built
# from the same MeshLLM release and the llama.cpp release that release pins.

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

version="$(curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
  https://api.github.com/repos/Mesh-LLM/mesh-llm/releases/latest | jq -er '.tag_name | ltrimstr("v")')"

# The runtime's own script, found through its package file.
runtime="$(nix-instantiate --eval -E 'with import ./. { }; skippy-native-runtime.meta.position' | tr -d '"' | cut -d: -f1)"
"$(dirname "$runtime")/update-release.sh" skippy-native-runtime "$version"

# mesh-llm takes its version, source and cargo hash from the runtime; refresh the
# web console's dependency hash.
nix-update mesh-llm --version skip
