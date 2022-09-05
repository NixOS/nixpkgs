#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p coreutils gnused curl common-updater-scripts nix-prefetch-git jq
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

DEPS_FILE="$(realpath "./deps.nix")"

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
    RELEASE_JOB_DATA=$(
        curl -s -H "Accept: application/vnd.github.v3+json" \
            ${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
            https://api.github.com/repos/Ryujinx/Ryujinx/actions/workflows
    )
    if [ -z "$RELEASE_JOB_DATA" ] || [[ $RELEASE_JOB_DATA =~ "rate limit exceeded" ]]; then
        echo "failed to get release job data" >&2
        exit 1
    fi
    RELEASE_JOB_ID=$(echo "$RELEASE_JOB_DATA" | jq -r '.workflows[] | select(.name == "Release job") | .id')
    RELEASE_JOB_FILE=$(echo "$RELEASE_JOB_DATA" | jq -r '.workflows[] | select(.name == "Release job") | .path')

    LATEST_RELEASE_JOB_DATA=$(
        curl -s -H "Accept: application/vnd.github.v3+json" \
            ${GITHUB_TOKEN:+ -H "Authorization: bearer $GITHUB_TOKEN"} \
            "https://api.github.com/repos/Ryujinx/Ryujinx/actions/workflows/${RELEASE_JOB_ID}/runs"
    )
    if [ -z "$LATEST_RELEASE_JOB_DATA" ] || [[ $LATEST_RELEASE_JOB_DATA =~ "rate limit exceeded" ]]; then
        echo "failed to get latest release job data" >&2
        exit 1
    fi
    COMMIT=$(echo "$LATEST_RELEASE_JOB_DATA" | jq -r '.workflow_runs[0] | .head_sha')
    PATCH_VERSION=$(echo "$LATEST_RELEASE_JOB_DATA" | jq -r '.workflow_runs[0] | .run_number')

    BASE_VERSION=$(
        curl -s "https://raw.githubusercontent.com/Ryujinx/Ryujinx/master/${RELEASE_JOB_FILE}" |
            grep -Po 'RYUJINX_BASE_VERSION:.*?".*"' |
            sed 's/RYUJINX_BASE_VERSION: "\(.*\)"/\1/'
    )

    NEW_VERSION="${BASE_VERSION}.${PATCH_VERSION}"
fi

OLD_VERSION="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

echo "comparing versions $OLD_VERSION -> $NEW_VERSION"
if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    echo "Already up to date!"
    if [[ "${1-default}" != "--deps-only" ]]; then
      exit 0
    fi
fi

cd ../../../..

if [[ "${1-default}" != "--deps-only" ]]; then
    SHA="$(nix-prefetch-git https://github.com/ryujinx/ryujinx --rev "$COMMIT" --quiet | jq -r '.sha256')"
    update-source-version ryujinx "$NEW_VERSION" "$SHA" --rev="$COMMIT"
fi

echo "building Nuget lockfile"

$(nix-build -A ryujinx.fetch-deps --no-out-link) "$DEPS_FILE"
