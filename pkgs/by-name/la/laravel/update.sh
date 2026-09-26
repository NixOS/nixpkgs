#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq php.packages.composer nix-update coreutils

set -eou pipefail

PACKAGE_NAME="laravel"
PACKAGE_VERSION=$(nix eval --raw -f. $PACKAGE_NAME.version)
PACKAGE_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Get latest version from git
GIT_VERSION="$(curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/laravel/installer/releases/latest" | jq '.tag_name' --raw-output)"
NEW_VERSION="${GIT_VERSION#v}"

# Fail if package and git version are the same
if [[ "$PACKAGE_VERSION" == "$NEW_VERSION" ]]; then
    echo "${PACKAGE_NAME} is up-to-date: ${PACKAGE_VERSION}"
    exit 0
fi

# Generate composer.lock file
TMPDIR=$(mktemp -d)
trap 'rm -rf -- "${TMPDIR}"' EXIT

git clone --depth 1 --branch "${GIT_VERSION}" https://github.com/laravel/installer.git "${TMPDIR}/laravel"
composer -d "${TMPDIR}/laravel" install
cp "${TMPDIR}/laravel/composer.lock" "${PACKAGE_DIR}/composer.lock"

# update package.nix version, hash and vendorHash
nix-update $PACKAGE_NAME --version="${NEW_VERSION}"
