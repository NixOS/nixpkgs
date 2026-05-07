#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update yq

set -euo pipefail

nix-update session-desktop

pnpmLock="$(nix-build -A session-desktop.src --no-out-link)/pnpm-lock.yaml"
depVersion() {
  name="$(echo "$1" | sed 's/\//\\&/g')"
  yq -r ".packages | with_entries(select(.key | startswith(\"$name@\"))) | .[].version" "$pnpmLock"
}

nix-update session-desktop.passthru.libsession-util-nodejs --version "$(depVersion libsession_util_nodejs)"
