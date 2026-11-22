#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update gnused

set -euo pipefail

nix-update noise-repellent "$@"

if [ "$(nix-instantiate --eval --raw -A noise-repellent.version)" = "${UPDATE_NIX_OLD_VERSION:-}" ]; then
  echo "Already up to date!"
  exit 0
fi

# Upstream pins the libspecbleach tag it was built against; follow it.
src=$(nix-build -A noise-repellent.src --no-out-link)
specbleach_version=$(sed -n 's/^[[:space:]]*GIT_TAG[[:space:]]*v\([0-9.]*\).*/\1/p' "$src/CMakeLists.txt" | head -n1)

if [ -z "$specbleach_version" ]; then
  echo "Could not determine required libspecbleach version" >&2
  exit 1
fi

nix-update libspecbleach --version="$specbleach_version"
