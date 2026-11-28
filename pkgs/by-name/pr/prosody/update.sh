#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep mercurial common-updater-scripts

set -euo pipefail

oldVersion=$(nix-instantiate --eval -A prosody.version | tr -d '"')
version=$(curl -sSfL https://prosody.im/downloads/source/ \
  | grep -oP 'prosody-\K[0-9.]+(?=\.tar\.gz)' | sort -uV | tail -n1)

if [[ "$version" == "$oldVersion" ]]; then
  echo "prosody is up-to-date: $version"
  exit 0
fi

update-source-version prosody "$version"

oldRev=$(nix-instantiate --eval -A prosody.drvAttrs.communityModules.rev | tr -d '"')
rev=$(hg identify -r default https://hg.prosody.im/prosody-modules)
if [[ "$rev" != "$oldRev" ]]; then
  update-source-version prosody --ignore-same-version \
    --source-key=drvAttrs.communityModules --rev="$rev"
fi
