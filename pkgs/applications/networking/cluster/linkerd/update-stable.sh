#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq

set -x -eu -o pipefail

cd $(dirname "$0")

VERSION=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} \
    --silent https://api.github.com/repos/linkerd/linkerd2/releases | \
    jq 'map(.tag_name)' | grep -v -e '-rc' | grep stable | sed 's/["|,| ]//g' | sed 's/stable-//' | sort -V -r | head -n1)

SHA256=$(nix-prefetch-url --quiet --unpack https://github.com/linkerd/linkerd2/archive/refs/tags/stable-${VERSION}.tar.gz)

setKV () {
  sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" ./default.nix
}

setKV version ${VERSION}
setKV sha256 ${SHA256}
setKV vendorHash "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=" # Necessary to force clean build.

cd ../../../../../
set +e
VENDOR_HASH=$(nix-build --no-out-link -A linkerd 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g')
set -e
cd - > /dev/null

if [ -n "${VENDOR_HASH:-}" ]; then
  setKV vendorHash ${VENDOR_HASH}
else
  echo "Update failed. VENDOR_HASH is empty."
  exit 1
fi
