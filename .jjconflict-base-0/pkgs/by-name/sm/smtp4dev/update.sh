#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update

version=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sfL "https://api.github.com/repos/rnwood/smtp4dev/releases/latest" | jq -r .tag_name)
nix-update --version="$version" smtp4dev
