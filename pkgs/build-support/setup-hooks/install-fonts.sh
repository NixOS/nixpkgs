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

  local ext="$1"
  local targetDir="$2"
  local findExpr=()

  set -f
  includeFonts=(${includeFonts[@]})
  excludeFonts=(${excludeFonts[@]})
  set +f

  if [ ${#includeFonts[@]} -gt 0 ]; then

    findExpr+=( \( )
    for p in "${includeFonts[@]}"; do
      findExpr+=( "-iname" "$p.$ext" "-o" )
    done
    unset 'findExpr[${#findExpr[@]}-1]'
    findExpr+=( \) )
  else
    findExpr+=( -iname "*.$ext" )
  fi

  for p in "${excludeFonts[@]}"; do
    findExpr+=( -not -iname "$p.$ext" )
  done

  find . -type f "${findExpr[@]}" -print0 | \
    xargs -0 -r install -m644 -D -t "$targetDir"
}

installFonts() {
  if [ "${dontInstallFonts-}" == 1 ]; then return; fi

  declare -A font_dirs=(
    ["ttf ttc"]="$out/share/fonts/truetype"
    ["otf otc"]="$out/share/fonts/opentype"
    ["pfa pfb pfm afm"]="$out/share/fonts/type1"
    ["bdf pcf otb"]="$out/share/fonts/misc"
    ["psf psfu"]="$out/share/consolefonts"
  )

  for exts in "${!font_dirs[@]}"; do
    for ext in $exts; do
      installFont "$ext" "${font_dirs[$exts]}"
    done
  done

  if [ -n "${webfont-}" ]; then
    installFont 'woff' "$webfont/share/fonts/woff"
    installFont 'woff2' "$webfont/share/fonts/woff2"
  fi
}
