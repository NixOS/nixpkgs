#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p coreutils gnused curl common-updater-scripts nix-prefetch-git jq
# shellcheck shell=bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

# If NEW_VERSION or COMMIT are not set, fetch the latest version
if [ -z ${NEW_VERSION+x} ] && [ -z ${COMMIT+x} ]; then
    RELEASE_DATA=$(curl -s "https://git.ryujinx.app/api/v4/projects/1/repository/tags?order_by=updated&sort=desc")
    if [ -z "$RELEASE_DATA" ] || [[ $RELEASE_DATA =~ "imposed ratelimits" ]]; then
        echo "failed to get release job data" >&2
        exit 1
    fi
    NEW_VERSION=$(echo "$RELEASE_DATA" | jq -r '[.[] | select(.name | startswith("Canary") | not)][0].name')
fi

OLD_VERSION="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./package.nix)"

echo "comparing versions $OLD_VERSION -> $NEW_VERSION"
if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    echo "Already up to date!"
    if [[ "${1-default}" != "--deps-only" ]]; then
      exit 0
    fi
fi

cd ../../../..

if [[ "${1-default}" != "--deps-only" ]]; then
    SHA="$(nix-prefetch-git https://git.ryujinx.app/ryubing/ryujinx --rev "$NEW_VERSION" --quiet | jq -r '.sha256')"
    SRI=$(nix --experimental-features nix-command hash to-sri "sha256:$SHA")
    update-source-version ryubing "$NEW_VERSION" "$SRI"
fi

echo "building Nuget lockfile"

eval "$(nix-build -A ryubing.fetch-deps --no-out-link)"
