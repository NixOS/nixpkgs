#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq

set -x -eu -o pipefail

WORKDIR=$(mktemp -d)
trap "rm -rf ${WORKDIR}" EXIT

NIXPKGS_CRC_FOLDER=$(
    cd $(dirname ${BASH_SOURCE[0]})
    pwd -P
)
cd ${NIXPKGS_CRC_FOLDER}

LATEST_TAG_RAWFILE=${WORKDIR}/latest_tag.json
curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/crc-org/crc/releases  >${LATEST_TAG_RAWFILE}

LATEST_TAG_NAME=$(jq 'map(.tag_name)' ${LATEST_TAG_RAWFILE} |
    grep -v -e rc -e engine | tail -n +2 | head -n -1 | sed 's|[", ]||g' | sort -rV | head -n1)

CRC_VERSION=$(echo ${LATEST_TAG_NAME} | sed 's/^v//')

CRC_COMMIT=$(curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/crc-org/crc/tags |
    jq -r "map(select(.name == \"${LATEST_TAG_NAME}\")) | .[0] | .commit.sha")

CRC_GIT_PREFETCH=$(nix-prefetch-url --unpack https://github.com/crc-org/crc/archive/${CRC_COMMIT}.tar.gz)
CRC_GIT_HASH=$(nix hash to-sri --type sha256 ${CRC_GIT_PREFETCH})

FILE_MAKEFILE=${WORKDIR}/Makefile
curl --silent https://raw.githubusercontent.com/crc-org/crc/${CRC_COMMIT}/Makefile >$FILE_MAKEFILE

OPENSHIFT_VERSION=$(grep 'OPENSHIFT_VERSION' ${FILE_MAKEFILE} |
    head -n1 | awk '{print $3}')

OKD_VERSION=$(grep 'OKD_VERSION' ${FILE_MAKEFILE} |
    head -n1 | awk '{print $3}')

PODMAN_VERSION=$(grep 'PODMAN_VERSION' ${FILE_MAKEFILE} |
    head -n1 | awk '{print $3}')

WRITE_KEY=$(grep '$(REPOPATH)/pkg/crc/segment.WriteKey' ${FILE_MAKEFILE} |
    head -n1 | awk '{print $4}' | sed -e 's/$(REPOPATH)\/pkg\/crc\/segment.WriteKey=//g')

sed -i "s|version = \".*\"|version = \"${CRC_VERSION:-}\"|" \
    ${NIXPKGS_CRC_FOLDER}/default.nix

sed -i "s|gitCommit = \".*\"|gitCommit = \"${CRC_COMMIT:-}\"|" \
    ${NIXPKGS_CRC_FOLDER}/default.nix

sed -i "s|gitHash = \".*\"|gitHash = \"${CRC_GIT_HASH}\"|" \
    ${NIXPKGS_CRC_FOLDER}/default.nix

sed -i "s|openShiftVersion = \".*\"|openShiftVersion = \"${OPENSHIFT_VERSION:-}\"|" \
    ${NIXPKGS_CRC_FOLDER}/default.nix

sed -i "s|okdVersion = \".*\"|okdVersion = \"${OKD_VERSION:-}\"|" \
    ${NIXPKGS_CRC_FOLDER}/default.nix

sed -i "s|podmanVersion = \".*\"|podmanVersion = \"${PODMAN_VERSION:-}\"|" \
    ${NIXPKGS_CRC_FOLDER}/default.nix

sed -i "s|writeKey = \".*\"|writeKey = \"${WRITE_KEY:-}\"|" \
    ${NIXPKGS_CRC_FOLDER}/default.nix
