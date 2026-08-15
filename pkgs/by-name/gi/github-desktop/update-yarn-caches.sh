#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix gnused common-updater-scripts

set -euxo pipefail

cd "$(dirname $0)"

setKV() {
  sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" package.nix
}

for cache in cacheApp cacheRoot; do
  hashKey="${cache}Hash"
  setKV "$hashKey" sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=

  pushd ../../../..
  set +e
  newHash="$(nix-build --no-out-link -A github-desktop.$cache 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g')"
  set -e
  popd

  if [ -z "$newHash" ]; then
    echo Failed to update hash for $cache
    exit 1
  fi
  setKV "$hashKey" "$newHash"
done
