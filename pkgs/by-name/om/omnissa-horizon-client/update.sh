#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts nix
set -e

entryPointURL='https://customerconnect.omnissa.com/channel/public/api/v1.0/products/getRelatedDLGList?locale=en_US&category=desktop_end_user_computing&product=omnissa_horizon_clients&version=8&dlgType=PRODUCT_BINARY'

function getTarballMetaUrl {
    curl "$entryPointURL" | jq -r '
        .dlgEditionsLists | .[] | select(.name | contains("Client for Linux")) |
        .dlgList | .[] | select(.name | contains("tarball version")) |
        @uri "https://customerconnect.omnissa.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=\(.code)&productId=\(.productId)&rPId=\(.releasePackageId)"
    '
}

meta="$( curl "$(getTarballMetaUrl)" | jq ".downloadFiles[]" )"

ver="$( echo "$meta" | jq -r .version )"
url="$( echo "$meta" | jq -r .thirdPartyDownloadUrl )"
sum="$( echo "$meta" | jq -r .sha256checksum )"
sriHash="$(nix hash convert --hash-algo sha256 --to sri "$sum")"
# nix hash convert --from sri --to base16 --hash-algo sha256 "SRI-HASH-HERE"

echo
echo "version: $ver"
echo "tar url: $url"
echo " sha256: $sum"
echo "   hash: $sriHash"

cd "$(dirname "$0")/../../../../.."
update-source-version omnissa-horizon-client.unwrapped "$ver" "$sriHash" "$url"
