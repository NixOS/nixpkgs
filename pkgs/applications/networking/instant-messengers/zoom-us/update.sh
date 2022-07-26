#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup

set -eu -o pipefail

dirname="$(dirname "$0")"

uname="$(uname)"

if [[ "$uname" == "Linux" ]]; then
    version="$(curl -Ls https://zoom.us/download\?os\=linux | \
      pup '.linux-ver-text text{}' | \
      awk -F'[ ().]' '{printf $2"."$3"."$4"."$6"\n"}')"
    printf '"%s"\n' ${version} > $dirname/x86_64-linux-version.nix
    printf '"%s"\n' \
        $(nix-prefetch-url https://zoom.us/client/${version}/zoom_x86_64.pkg.tar.xz) > \
        $dirname/x86_64-linux-sha.nix
elif [[ $uname == "Darwin" ]]; then
    # The 1st line might be empty
    # 2nd line is the version of the conference room application
    version="$(curl -Ls https://zoom.us/download\?os\=mac | \
      pup '.ver text{}' | \
      sed '/^$/d' |\
      head -1 | \
      awk -F'[ ().]' '{printf $2"."$3"."$4"."$6"\n"}')"
    printf '"%s"\n' ${version} > "$dirname/$(uname -m)-darwin-version.nix"
    printf '"%s"\n' \
        $(nix-prefetch-url "https://zoom.us/client/${version}/Zoom.pkg?archType=$(uname -m)") > \
        "$dirname/$(uname -m)-darwin-sha.nix"
fi
