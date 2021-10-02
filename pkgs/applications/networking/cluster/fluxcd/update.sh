#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq

set -eu -o pipefail

cd $(dirname "${BASH_SOURCE[0]}")

TAG=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} --silent https://api.github.com/repos/fluxcd/flux2/releases/latest | jq -r '.tag_name')

VERSION=$(echo ${TAG} | sed 's/^v//')

SHA256=$(nix-prefetch-url --quiet --unpack https://github.com/fluxcd/flux2/archive/refs/tags/${TAG}.tar.gz)

SPEC_SHA256=$(nix-prefetch-url --quiet --unpack https://github.com/fluxcd/flux2/releases/download/${TAG}/manifests.tar.gz)

setKV () {
  sed -i "s/$1 = \".*\"/$1 = \"$2\"/" ./default.nix
}

setKV version ${VERSION}
setKV sha256 ${SHA256}
setKV manifestsSha256 ${SPEC_SHA256}
setKV vendorSha256 ""

cd ../../../../../
set +e
VENDOR_SHA256=$(nix-build --no-out-link -A fluxcd 2>&1 | grep "got:" | cut -d':' -f2 | sed 's/ //g')
set -e

cd - > /dev/null
setKV vendorSha256 ${VENDOR_SHA256}
