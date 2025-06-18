#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -eu -o pipefail

# Get linux version
OS=$(uname -s| tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m| tr '[:upper:]' '[:lower:]')

curl -#L "https://dv-binaries.s3.us-east-2.amazonaws.com/linux_x86_64/dv" --output "./dv"
chmod a+x ./dv

new_version="$(./dv --version | grep -oP '(\d+\.)?(\d+\.)?(\*|\d+).*')"

update-source-version diversion-cli "$new_version"

rm ./dv
