#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update yq python3

set -euo pipefail

oldVersion="$(nix-instantiate --eval --raw -A session-desktop.version)"
nix-update --src-only session-desktop
if [[ "$(nix-instantiate --eval --raw -A session-desktop.version)" = "$oldVersion" ]]; then
  echo 'No new version' >&2
  exit
fi

pnpmLock="$(nix-build -A session-desktop.src --no-out-link)/pnpm-lock.yaml"
depVersion() {
  name="$(echo "$1" | sed 's/\//\\&/g')"
  yq -r ".packages | with_entries(select(.key | startswith(\"$name@\"))) | .[].version" "$pnpmLock"
}

# pnpm >= 10.34.1 requires integrity hashes for tarball dependencies
# remove after upstream uses the new lockfile standards
nixDir="$(dirname "$(nix-instantiate --eval --raw -A session-desktop.meta.position | cut -d: -f1)")"
"$nixDir/generate_pnpm_patch.py" "$pnpmLock" "$nixDir/add-pnpm-tarball-integrities.patch"

nix-update --no-src --version skip session-desktop

nix-update session-desktop.passthru.libsession-util-nodejs --version "$(depVersion libsession_util_nodejs)"
