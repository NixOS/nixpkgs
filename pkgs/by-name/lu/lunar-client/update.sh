#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts
set -eu -o pipefail

redirect=$(curl -fsS --head -o /dev/null -w '%{redirect_url}' 'https://api.lunarclientprod.com/site/download?os=linux')
[[ "$redirect" =~ Lunar([ ]|%20)Client-([0-9]+\.[0-9]+\.[0-9]+)-ow\.AppImage ]] || {
  echo "update.sh: could not parse version from $redirect" >&2
  exit 1
}
update-source-version lunar-client "${BASH_REMATCH[2]}" "" "${redirect// /%20}"
