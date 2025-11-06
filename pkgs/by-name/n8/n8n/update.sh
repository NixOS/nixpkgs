#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p bash curl jq nix-update cacert git
set -euo pipefail

new_version="$(curl -s "https://api.github.com/repos/n8n-io/n8n/releases/latest" | jq --raw-output '.tag_name | ltrimstr("n8n@")')"
nix-update n8n --version "$new_version"
