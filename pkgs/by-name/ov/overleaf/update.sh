#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl git gnugrep jq nix-update

set -euxo verbose

TAG=$(curl -s "https://hub.docker.com/v2/repositories/sharelatex/sharelatex/tags" | jq -r .results[2].name)
REV=$(curl -s "https://hub.docker.com/v2/repositories/sharelatex/sharelatex/tags/$TAG/images" | jq .[0].layers | grep -Po "MONOREPO_REVISION=\K[a-z0-9]*" -m 1)

nix-update overleaf --version branch="$REV"

update-source-version overleaf "$TAG" --ignore-same-hash
