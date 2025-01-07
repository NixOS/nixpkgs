#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git bash curl jq nix-update

set -xe

dirname="$(dirname "$0")"

latestTag=$(curl https://api.github.com/repos/ferdium/ferdium-app/releases/latest | jq -r ".tag_name")
latestVersion="$(expr $latestTag : 'v\(.*\)')"

nix-update --version "$latestVersion" --system aarch64-linux --override-filename "$dirname/default.nix" ferdium
nix-update --version skip --system x86_64-linux --override-filename "$dirname/default.nix" ferdium
