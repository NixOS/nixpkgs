#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnused nix-update

set -eu -o pipefail
set -x

# Compute the relative dir of the update script
SCRIPT_DIR="$(cd -- "$(dirname "$0")" >/dev/null 2>&1; pwd -P)"

# Update version, src hash, and vendor hash
nix-update fluxcd

# Read the potentially updated version from `nix-update fluxcd` using SCRIPT_DIR
VERSION=$(sed -n 's/.*version = "\(.*\)".*/\1/p' "${SCRIPT_DIR}/package.nix" | head -1)

# Update the additional fluxcd manifests hash
# This is idempotent and will run regardless of whether nix-update changes the package.nix version
# note: tag format is assumed to be v${VERSION} which matches the fetchZip in package.nix
MANIFESTS_SHA256=$(nix-prefetch-url --quiet --unpack "https://github.com/fluxcd/flux2/releases/download/v${VERSION}/manifests.tar.gz")
MANIFESTS_HASH=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$MANIFESTS_SHA256")
sed -i "s|manifestsHash = \".*\"|manifestsHash = \"${MANIFESTS_HASH}\"|" "${SCRIPT_DIR}/package.nix"
