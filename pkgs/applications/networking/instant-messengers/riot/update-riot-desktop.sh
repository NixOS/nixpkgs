#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../../ -i bash -p wget yarn2nix

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
	echo "Regenerates the Yarn dependency lock files for the riot-desktop package."
	echo "Usage: $0 <git release tag>"
	exit 1
fi

RIOT_WEB_SRC="https://raw.githubusercontent.com/vector-im/riot-desktop/$1"

wget "$RIOT_WEB_SRC/package.json" -O riot-desktop-package.json
wget "$RIOT_WEB_SRC/yarn.lock" -O riot-desktop-yarndeps.lock
yarn2nix --lockfile=riot-desktop-yarndeps.lock > riot-desktop-yarndeps.nix
rm riot-desktop-yarndeps.lock
