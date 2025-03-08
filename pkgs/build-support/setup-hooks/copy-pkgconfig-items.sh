# shellcheck shell=bash

# Setup hook that installs specified pkgconfig items.
#
# Example usage in a derivation:
#
#   { …, makePkgconfigItem, copyPkgconfigItems, … }:
#
#   let pkgconfigItem = makePkgconfigItem { … }; in
#   stdenv.mkDerivation {
#     …
#     nativeBuildInputs = [ copyPkgconfigItems ];
#
#     pkgconfigItems =  [ pkgconfigItem ];
#     …
#   }
#
# This hook will copy files which are either given by full path
# or all '*.pc' files placed inside the 'lib/pkgconfig'
# folder of each `pkgconfigItems` argument.

postInstallHooks+=(copyPkgconfigItems)

copyPkgconfigItems() {
    if [ "${dontCopyPkgconfigItems-}" = 1 ]; then return; fi

    if [ -z "$pkgconfigItems" ]; then
        return
    fi

    pkgconfigdir="${!outputDev}/lib/pkgconfig"
    for pkgconfigItem in $pkgconfigItems; do
        if [[ -f "$pkgconfigItem" ]]; then
            substituteAllInPlace "$pkgconfigItem"
            echo "Copying '$pkgconfigItem' into '${pkgconfigdir}'"
            install -D -m 444 -t "${pkgconfigdir}" "$pkgconfigItem"
            substituteAllInPlace "${pkgconfigdir}"/*
        else
            for f in "$pkgconfigItem"/lib/pkgconfig/*.pc; do
                echo "Copying '$f' into '${pkgconfigdir}'"
                install -D -m 444 -t "${pkgconfigdir}" "$f"
                substituteAllInPlace "${pkgconfigdir}"/*
            done
        fi
    done
}
