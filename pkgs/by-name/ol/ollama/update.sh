#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts nix-update
# shellcheck shell=bash

set -euo pipefail

nix-update ollama --src-only

ollama_src=$(nix-build --no-out-link -A ollama.src)
llama_cpp_version=$(<"$ollama_src/LLAMA_CPP_VERSION")

if [[ -z "$llama_cpp_version" ]]; then
  echo "LLAMA_CPP_VERSION is empty" >&2
  exit 1
fi

update-source-version ollama "$llama_cpp_version" \
  --source-key=llamaCppSrc \
  --version-key=llamaCppVersion

nix-update ollama --version=skip
