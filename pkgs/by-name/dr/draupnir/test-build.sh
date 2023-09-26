#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix coreutils

if [ ! -z "$CLEAN" ]; then
  nix-env -e draupnir
  nix-store --gc
  nix-collect-garbage -d
fi

nix-build -K -A draupnir

if [ ! -z "$INSTALL" ]; then
  nix-env -e draupnir
  nix-env -f . -iA draupnir
fi

if [ ! -z "$RUN" ]; then
  draupnir
fi

