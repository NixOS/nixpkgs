#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts gnused nixfmt-rfc-style

set -eu -o pipefail

version=${1:-$(curl -s https://api.github.com/repos/snakemake/snakemake/releases/latest | jq --raw-output '.tag_name[1:]')}
update-source-version snakemake $version

basedir="$(dirname "$0")"
cat <<EOF > "$basedir/assets.nix"
{ fetchurl }:
{
EOF
outlink="$basedir/src"
nix-build . -A snakemake.src -o "$outlink"
sed "$outlink"/snakemake/assets/__init__.py -n -f "$basedir/assets.sed" >> "$basedir/assets.nix"
rm "$outlink"
cat <<EOF >> "$basedir/assets.nix"
}
EOF
nixfmt "$basedir/assets.nix"
