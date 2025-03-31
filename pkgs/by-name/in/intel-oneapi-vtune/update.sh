#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -e

# Check on https://www.intel.com/content/www/us/en/developer/tools/oneapi/vtune-profiler-download.html
DOWNLOAD_ID=bef05a56-52f3-40ad-a91a-040a98316680

INSTALLER_URL=$(
    curl --silent "https://www.intel.com/libs/apps/intel/idz/productsinfo?downloadId=$DOWNLOAD_ID" |
        jq -r '
            .downloads.downloads.productVersionsBuilds[0].files[]
            | select (.operatingSystem == "Linux" and .fileType == "Custom Package")
            .url
        ' |
        uniq
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
