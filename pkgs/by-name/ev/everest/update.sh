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

update-source-version everest $version --rev=$commit
echo > "$(dirname "$(nix-instantiate --eval --strict -A everest.meta.position | sed -re 's/^"(.*):[0-9]+"$/\1/')")/deps.json"
"$(nix-build --attr everest.fetch-deps --no-out-link)"
update-source-version everest-bin $version "" $url
