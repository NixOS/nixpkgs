# shellcheck shell=bash

# Setup hook that installs font files to their respective locations.
#
# Example usage in a derivation:
#
#   { …, installFonts, … }:
#
#   stdenvNoCC.mkDerivation {
#     …
#     outputs = [
#       "out"
#       "webfont" # If .woff or .woff2 output is desired
#     ];
#
#     nativeBuildInputs = [ installFonts ];
#     …
#   }
#
# This hook also provides an `installFont` function that can be used to install
# additional fonts of a particular extension into their respective folder.
#
postInstallHooks+=(installFonts)

installFont() {
  if (($# != 2)); then
    nixErrorLog "expected 2 arguments!"
    nixErrorLog "usage: installFont fontExt outDir"
    exit 1
  fi

  find -iname "*.$1" -print0 | xargs -0 -r install -m644 -D -t "$2"
}

installFonts() {
  if [ "${dontInstallFonts-}" == 1 ]; then return; fi

  installFont 'ttf' "$out/share/fonts/truetype"
  installFont 'ttc' "$out/share/fonts/truetype"
  installFont 'otf' "$out/share/fonts/opentype"
  installFont 'bdf' "$out/share/fonts/misc"
  installFont 'otb' "$out/share/fonts/misc"
  installFont 'psf' "$out/share/consolefonts"

  if [ -n "${webfont-}" ]; then
    installFont 'woff' "$webfont/share/fonts/woff"
    installFont 'woff2' "$webfont/share/fonts/woff2"
  fi

}
