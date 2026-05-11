#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnugrep nix-update coreutils
set -ex

TAGS=$(curl -s https://api.github.com/repos/owncloud/ocis/releases | jq -r ".[].tag_name")

for tag in $TAGS; do
    main_version_old=$(echo "v$UPDATE_NIX_OLD_VERSION" | cut -d'.' -f1)
    main_version_new=$(echo "$tag" | cut -d'.' -f1)

    # Compare the main versions
    if [[ "$main_version_old" == "$main_version_new" ]]; then
        UPDATE_NIX_NEW_VERSION=$tag
        break
    else
        continue
    fi
done

OCIS_WEB_VERSION=$(curl -s https://raw.githubusercontent.com/owncloud/ocis/$UPDATE_NIX_NEW_VERSION/services/web/Makefile | grep -oP '(?<=WEB_ASSETS_VERSION = )v[0-9]+\.[0-9]+\.[0-9]+')
nix-update -vr 'v(.*)' --version=$OCIS_WEB_VERSION ocis.web
nix-update -vr 'v(.*)' --version=$UPDATE_NIX_NEW_VERSION ocis
