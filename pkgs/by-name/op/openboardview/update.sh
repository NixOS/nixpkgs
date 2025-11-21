#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update git jq
# shellcheck shell=bash

ROOT=$(git rev-parse --show-toplevel)
ATTR=openboardview

cd "$ROOT" || exit 1

# get current version in nixpkgs
CURRENT_VERSION=$(nix eval -f ./default.nix --raw "$ATTR.version")

# get latest release tag
LATEST_VERSION=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s 'https://api.github.com/repos/OpenBoardView/OpenBoardView/releases' | jq -r  'map(select(.prerelease == false)) | .[0].tag_name')

# strip quotes
LATEST_VERSION=${LATEST_VERSION%\"}
LATEST_VERSION=${LATEST_VERSION#\"}

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ];
then
  echo Already on latest version
  exit 0
fi

PKGDIR=$(dirname "$0")

# change to package directory
cd "$PKGDIR" || exit 1

# update package
cd "$ROOT" || exit 1
nix-update --version "$LATEST_VERSION" "$ATTR"

