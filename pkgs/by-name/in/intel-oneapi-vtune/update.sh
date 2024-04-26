#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -e

INSTALLER_URL=$(
    curl --silent "https://www.intel.com/libs/apps/intel/idz/productsinfo?downloadId=3426" |
        jq -r '
            .downloads.downloads.productVersionsBuilds[0].files[]
            | select (.operatingSystem == "Linux" and .fileType == "Custom Package")
            .url
        '
)
echo "INSTALLER_URL=$INSTALLER_URL"
[ "$INSTALLER_URL" ] || exit 1

{
    read -r CUP_URL
    read -r VERSION
} < <(
    curl --silent "$INSTALLER_URL" |
        sed '0,/^__CONTENT__$/d' |
        tar -zx -O --wildcards './packages/intel.oneapi.lin.vtune,v=*/manifest.json' |
        jq -r '
            [(.payloads[] | select (.fileName == "cupPayload.cup") | .url),
             (.version | split("+")[0])
            ][]
        '
)
echo "CUP_URL=$CUP_URL"
echo "VERSION=$VERSION"
[ "$CUP_URL" ] || exit 1
[ "$VERSION" ] || exit 1

CUP_HASH=$(nix-prefetch-url "$CUP_URL")
echo "CUP_HASH=$CUP_HASH"

update-source-version intel-oneapi-vtune "$VERSION" "$CUP_HASH" "$CUP_URL"
