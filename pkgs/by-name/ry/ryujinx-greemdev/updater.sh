#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p coreutils gnused curl common-updater-scripts nix-prefetch-git jq
# shellcheck shell=bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

# provide a github token so you don't get rate limited
# if you use gh cli you can use:
#     `export GITHUB_TOKEN="$(cat ~/.config/gh/config.yml | yq '.hosts."github.com".oauth_token' -r)"`
# or just set your token by hand:
#     `read -s -p "Enter your token: " GITHUB_TOKEN; export GITHUB_TOKEN`
#     (we use read so it doesn't show in our shell history and in secret mode so the token you paste isn't visible)
if [ -z "${GITHUB_TOKEN:-}" ]; then
    echo "no GITHUB_TOKEN provided - you could meet API request limiting" >&2
fi

# or provide the new version manually
# manually modify and uncomment or export these env vars in your shell so they're accessable within the script
# make sure you don't commit your changes here
#
# NEW_VERSION=""
# COMMIT=""

if [ -z ${NEW_VERSION+x} ] && [ -z ${COMMIT+x} ]; then
    RELEASE_DATA=$(
        curl -s -H "Accept: application/vnd.github.v3+json" \
            ${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
            https://api.github.com/repos/GreemDev/Ryujinx/releases
    )
    if [ -z "$RELEASE_DATA" ] || [[ $RELEASE_DATA =~ "rate limit exceeded" ]]; then
        echo "failed to get release job data" >&2
        exit 1
    fi
    NEW_VERSION=$(echo "$RELEASE_DATA" | jq -r '.[0].name')
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
    SHA="$(nix-prefetch-git https://github.com/GreemDev/Ryujinx --rev "$NEW_VERSION" --quiet | jq -r '.sha256')"
    SRI=$(nix --experimental-features nix-command hash to-sri "sha256:$SHA")
    update-source-version ryujinx-greemdev "$NEW_VERSION" "$SRI"
fi

echo "building Nuget lockfile"

eval "$(nix-build -A ryujinx-greemdev.fetch-deps --no-out-link)"
