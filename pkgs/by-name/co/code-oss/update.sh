#!/usr/bin/env nix
#!nix shell .#bashNonInteractive .#nix-update .#nodejs --command bash

set -euxo pipefail

nix-update "${UPDATE_NIX_ATTR_PATH}.src"

curl "https://api.github.com/repos/microsoft/vscode/git/$(nix eval --raw .#code-oss.src.src.rev)" \
  | jq .object.url \
  | xargs curl \
  | jq -r .committer.date \
  > pkgs/by-name/co/code-oss/date
