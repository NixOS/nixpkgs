#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash curl jq nix-update cacert git
set -euo pipefail

new_version="$(curl -s 'https://api.github.com/repos/n8n-io/n8n/releases?per_page=30' | \
  jq -r '
    map(select(.prerelease | not) | .tag_name | sub("^n8n@"; ""))
    | sort_by(split(".") | map(tonumber)) | last
    ')"
nix-update n8n --version "$new_version"
