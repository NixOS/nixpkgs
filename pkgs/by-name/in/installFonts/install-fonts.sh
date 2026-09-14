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
preInstallHooks+=(installFonts)

installFont() {
  if (($# != 2)); then
    nixErrorLog "expected 2 arguments!"
    nixErrorLog "usage: installFont fontExt outDir"
    exit 1
  fi

  find -iname "*.$1" -print0 | xargs -0 -r install -m644 -D -t "$2"
}

handleBaseFontTypes() {
  local otfs=$(find -iname "*.otf")
  local otcs=$(find -iname "*.otc")
  set -f
  otfs=(${otfs[@]})
  otcs=(${otcs[@]})
  set +f

  # Individual fonts
  if [[ ${#otfs[@]} -eq 0 ]]; then
    installFont 'ttf' "$out/share/fonts/truetype"
  else
    if [ -n "${truetype-}" ]; then
      installFont 'ttf' "$truetype/share/fonts/truetype"
    else
      echo "ERROR: installFonts: Please create a 'truetype' output"
      exit 1
    fi
    for otffont in "${otfs[@]}"; do
      install -Dm644 "$otffont" -t "$out/share/fonts/opentype"
    done
  fi

  # Collections
  if [[ ${#otcs[@]} -eq 0 ]]; then
    installFont 'ttc' "$out/share/fonts/truetype"
  else
    if [ -n "${truetype-}" ]; then
      installFont 'ttc' "$truetype/share/fonts/truetype"
    else
      cho "ERROR: installFonts: Please create a 'truetype' output"
      exit 1
    fi
    for otcfont in "${otcs[@]}"; do
      install -Dm644 "$otcfont" -t "$out/share/fonts/opentype"
    done
  fi
}

installFonts() {
  if [ "${dontInstallFonts-}" == 1 ]; then return; fi

  handleBaseFontTypes

  installFont 'pfa' "$out/share/fonts/type1"
  installFont 'pfb' "$out/share/fonts/type1"
  installFont 'pfm' "$out/share/fonts/type1"
  installFont 'afm' "$out/share/fonts/type1"
  installFont 'bdf' "$out/share/fonts/misc"
  installFont 'pcf' "$out/share/fonts/misc"
  installFont 'otb' "$out/share/fonts/misc"
  installFont 'pcf.gz' "$out/share/fonts/misc"
  installFont 'psf' "$out/share/consolefonts"
  installFont 'psfu' "$out/share/consolefonts"

  if [ -n "${webfont-}" ]; then
    installFont 'woff' "$webfont/share/fonts/woff"
    installFont 'woff2' "$webfont/share/fonts/woff2"
  elif [[ "${dontInstallWebfonts-}" != 1 && -n "$(find . \( -iname "*.woff" -o -iname "*.woff2" \) -print)" ]]; then
    nixErrorLog "Consider adding \"webfont\" to outputs to install woff/woff2 files."
    nixErrorLog "Alternatively, set dontInstallWebfonts to silence this."
    exit 1
  fi
}
