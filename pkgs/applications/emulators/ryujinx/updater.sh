#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils gnused curl common-updater-scripts nuget-to-nix nix-prefetch-git jq dotnet-sdk_6
set -euxo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

DEPS_FILE="$(realpath "./deps.nix")"

RELEASE_JOB_DATA=$(
    curl -s -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/repos/Ryujinx/Ryujinx/actions/workflows |
        jq -r '.workflows[] | select(.name == "Release job") | { id, path }'
)
RELEASE_JOB_ID=$(echo "$RELEASE_JOB_DATA" | jq -r '.id')
RELEASE_JOB_FILE=$(echo "$RELEASE_JOB_DATA" | jq -r '.path')

BASE_VERSION=$(
    curl -s "https://raw.githubusercontent.com/Ryujinx/Ryujinx/master/${RELEASE_JOB_FILE}" |
        grep -Po 'RYUJINX_BASE_VERSION:.*?".*"' |
        sed 's/RYUJINX_BASE_VERSION: "\(.*\)"/\1/'
)

LATEST_RELEASE_JOB_DATA=$(
    curl -s -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/Ryujinx/Ryujinx/actions/workflows/${RELEASE_JOB_ID}/runs" |
        jq -r '.workflow_runs[0] | { head_sha, run_number }'
)
COMMIT=$(echo "$LATEST_RELEASE_JOB_DATA" | jq -r '.head_sha')
PATCH_VERSION=$(echo "$LATEST_RELEASE_JOB_DATA" | jq -r '.run_number')

NEW_VERSION="${BASE_VERSION}.${PATCH_VERSION}"

OLD_VERSION="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

echo "comparing versions $OLD_VERSION => $NEW_VERSION"
if [[ "$OLD_VERSION" == "$NEW_VERSION" ]]; then
    echo "Already up to date! Doing nothing"
    exit 0
fi

SHA="$(nix-prefetch-git https://github.com/ryujinx/ryujinx --rev "$COMMIT" --quiet | jq -r '.sha256')"

cd ../../../..
update-source-version ryujinx "$NEW_VERSION" "$SHA" --rev="$COMMIT"

STORE_SRC="$(nix-build . -A ryujinx.src --no-out-link)"
SRC="$(mktemp -d /tmp/ryujinx-src.XXX)"
cp -rT "$STORE_SRC" "$SRC"
chmod -R +w "$SRC"
pushd "$SRC"

mkdir nuget_tmp.packages
DOTNET_CLI_TELEMETRY_OPTOUT=1 dotnet restore Ryujinx.sln --packages nuget_tmp.packages

nuget-to-nix ./nuget_tmp.packages >"$DEPS_FILE"

popd
rm -r "$SRC"
