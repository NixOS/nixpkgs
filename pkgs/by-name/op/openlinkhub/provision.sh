#!/bin/sh
set -eu

cd "$1"

@coreutils@/ln -sfnT @out@/opt/OpenLinkHub/static static
@coreutils@/ln -sfnT @out@/opt/OpenLinkHub/web web

@coreutils@/mkdir -p database
@coreutils@/cp -rn --no-preserve=mode,ownership @out@/opt/OpenLinkHub/database/. database/

for name in config.json dashboard.json display.json; do
  if [ -f "@out@/opt/OpenLinkHub/$name" ] && [ ! -e "$name" ]; then
    @coreutils@/cp --no-preserve=mode,ownership "@out@/opt/OpenLinkHub/$name" "$name"
  fi
done

@coreutils@/printf '%s\n' '@version@' > .package-version
