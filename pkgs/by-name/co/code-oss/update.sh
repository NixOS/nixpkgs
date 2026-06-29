#!/usr/bin/env nix
#!nix shell --ignore-environment --keep UPDATE_NIX_ATTR_PATH .#bash .#nix-update .#git .#curl .#nix .#jq .#findutils --command bash

set -euxo pipefail

nix-update "${UPDATE_NIX_ATTR_PATH}.src"

curl "https://api.github.com/repos/microsoft/vscode/git/$(nix eval --raw .#code-oss.src.src.rev)" \
  | jq .object.url \
  | xargs curl \
  | jq '{sha: .sha, committer: {date: .committer.date}}' \
  > pkgs/by-name/co/code-oss/commit.json
