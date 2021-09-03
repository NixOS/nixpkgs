#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts

set -eu -o pipefail

version="$(curl -Ls https://www.bluejeans.com/download | \
    pup 'a[aria-label~="Linux"] attr{href}' | \
    #output contains *.deb and *.rpm
    grep "\.rpm" | \
    awk -F'[ ._ ]' '{printf $6"."$7"."$8"."$9"\n"}')"

update-source-version bluejeans-gui "$version"
