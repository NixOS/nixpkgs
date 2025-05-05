#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update

set -eou pipefail

version=$(curl ${GITLAB_TOKEN:+-H "Private-Token: $GITLAB_TOKEN"} -sL https://gitlab.com/api/v4/projects/15450933/repository/tags | jq -r '.[0].name')

nix-update --version="$version" glitchtip
nix-update --version="$version" glitchtip.frontend
