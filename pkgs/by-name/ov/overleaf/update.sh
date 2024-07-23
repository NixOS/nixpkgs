#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl git gnugrep jq nix-update

set -euxo verbose

VERSION=$(curl -s "https://hub.docker.com/v2/repositories/sharelatex/sharelatex/tags" | jq -r .results[2].name)
REV=$(curl -s "https://hub.docker.com/v2/repositories/sharelatex/sharelatex/tags/$VERSION/images" | jq .[0].layers | grep -Po "MONOREPO_REVISION=\K[a-z0-9]*" -m 1)

NIX_FILE=$(nix-instantiate --eval --strict -A "overleaf.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')
NIX_DIR=$(dirname "$NIX_FILE")
OLD_VERSION=$(nix-instantiate --eval --strict -A "overleaf.version")

if [ "$VERSION" != "$OLD_VERSION" ]; then
  (
      cd /tmp
      rm -rf overleaf
      git clone https://github.com/overleaf/overleaf
      cd overleaf
      git reset --hard "$REV"
      "$NIX_DIR"/patch-git-deps.py "$NIX_DIR"/git-deps.json
      cp package-lock.json "$NIX_DIR"
  )

  nix-update overleaf --version branch="$REV"
  update-source-version overleaf "$VERSION" --ignore-same-hash
fi
