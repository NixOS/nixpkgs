#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils gawk nix common-updater-scripts

set -euo pipefail

latest() {
  curl -fsSL "https://downloads.claude.ai/claude-desktop/apt/stable/dists/stable/main/binary-$1/Packages" \
    | awk '
        /^Package: / { pkg = ($2 == "claude-desktop") }
        pkg && /^Version: / { v = $2 }
        pkg && /^SHA256: / { print v, $2 }
      ' \
    | sort -V \
    | tail -n1
}

read -r version amd64Hash < <(latest amd64)
read -r arm64Version arm64Hash < <(latest arm64)

if [[ "$version" != "$arm64Version" ]]; then
  echo "amd64 ($version) and arm64 ($arm64Version) versions differ, not updating" >&2
  exit 1
fi

sri() {
  nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$1"
}

update-source-version claude-desktop "$version" "$(sri "$amd64Hash")" \
  --system=x86_64-linux --ignore-same-version
update-source-version claude-desktop "$version" "$(sri "$arm64Hash")" \
  --system=aarch64-linux --ignore-same-version
