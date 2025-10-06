#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -eu -o pipefail

branch=stable # set to one of dev, beta, stable
case $branch in
  dev) branches='"dev", "beta", "stable"' ;;
  beta) branches='"beta", "stable"' ;;
  stable) branches='"stable"' ;;
esac

endpoint=$(curl -s https://everestapi.github.io/everestupdater.txt)
endpoint="$endpoint$([[ "$endpoint" == *"?"* ]] && echo '&' || echo '?')supportsNativeBuilds=true"

latest=$(curl -s "$endpoint" | jq -r "map(select(.branch | IN($branches))) | max_by(.date)")
commit=$(echo "$latest" | jq -r .commit)
version=$(echo "$latest" | jq -r .version)
url=$(echo "$latest" | jq -r .mainDownload)

update-source-version celestegame.passthru.everest $version --rev=$commit
"$(nix-build --attr celestegame.passthru.everest.fetch-deps --no-out-link)"
update-source-version celestegame.passthru.everest-bin $version "" $url
