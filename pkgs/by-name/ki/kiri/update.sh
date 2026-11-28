#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update jq gnused
set -euo pipefail

nix-update kiri --system x86_64-linux

# darwin.nix takes its version from package.nix, so only the tarball hash moves.
darwin() { nix-instantiate --eval --raw -A "kiri.src.$1" --argstr system aarch64-darwin; }
old=$(darwin outputHash)
new=$(nix --extra-experimental-features nix-command store prefetch-file --json "$(darwin url)" | jq -r .hash)
sed -i "s|$old|$new|" pkgs/by-name/ki/kiri/darwin.nix
