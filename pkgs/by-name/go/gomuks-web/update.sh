#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update

set -euo pipefail

# Fetch latest release infor
RELEASE=$(curl -sSL https://api.github.com/repos/tulir/gomuks/releases/latest | jq -r .name)

if [ -z "$RELEASE" ]; then
    echo "Failed to fetch latest release"
    exit 1
fi

# Strip leading v from version
VERSION="${RELEASE#v}"

# Debug
echo "Release ${RELEASE} -> Version ${VERSION}"

nix-update --build --commit --version "${VERSION}" gomuks-web
