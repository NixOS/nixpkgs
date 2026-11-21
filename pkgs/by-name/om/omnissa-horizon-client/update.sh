#!/usr/bin/env nix-shell
#!nix-shell -p curl -p jq -p common-updater-scripts -i bash -p nix
set -e

entryPointURL='https://customerconnect.omnissa.com/channel/public/api/v1.0/products/getRelatedDLGList?locale=en_US&category=virtual_desktop_and_apps&product=omnissa_horizon_clients&version=8&dlgType=PRODUCT_BINARY'

function getTarballMetaUrl {
    curl "$entryPointURL" | jq -r '
        .dlgEditionsLists | .[] | select(.name | contains("Client for Linux")) |
        .dlgList | .[] | select(.name | contains("tarball version")) |
        @uri "https://customerconnect.omnissa.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=\(.code)&productId=\(.productId)&rPId=\(.releasePackageId)"
    '
}

meta="$( curl "$(getTarballMetaUrl)" | jq ".downloadFiles | .[]" )"

ver="$( echo "$meta" | jq -r .version )"
url="$( echo "$meta" | jq -r .thirdPartyDownloadUrl )"
sum="$( echo "$meta" | jq -r .sha256checksum )"
sri="$( nix hash convert --hash-algo sha256 --to sri "$sum")"

echo
echo "version: $ver"
echo "tar url: $url"
echo " sha256: $sum ($sri)"

cd "$(dirname "$0")/../../../.."
update-source-version omnissa-horizon-client.unwrapped "$ver" "$sri" "$url"
