#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gitMinimal jq nix-update
# shellcheck shell=bash

# Updates mesh-llm and mesh-llm-native-runtime together: the runtime is built
# from the same MeshLLM release and the llama.cpp release that release pins.

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

version="$(curl -sSfL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
  https://api.github.com/repos/Mesh-LLM/mesh-llm/releases/latest | jq -er '.tag_name | ltrimstr("v")')"

pkgs/by-name/me/mesh-llm-native-runtime/update-release.sh \
  pkgs/by-name/me/mesh-llm-native-runtime/package.nix mesh-llm-native-runtime "$version"

# mesh-llm takes its version and source from the runtime; refresh its own hashes.
nix-update mesh-llm --version skip
