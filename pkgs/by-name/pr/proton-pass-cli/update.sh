#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl
# shellcheck shell=bash

set -e

curl https://proton.me/download/pass-cli/versions.json >versions.json
