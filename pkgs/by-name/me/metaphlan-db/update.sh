#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pcre common-updater-scripts

set -euo pipefail

update-source-version metaphlan-db "$(curl -s http://cmprod1.cibio.unitn.it/biobakery4/metaphlan_databases/mpa_latest | sed -e "s/^mpa_v//")"
