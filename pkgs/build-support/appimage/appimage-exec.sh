#!@shell@
if [ -n "$DEBUG" ] ; then
  set -x
fi

PATH="@path@:$PATH"
apprun_opt=true

#DEBUG=0

# src : AppImage
# dest : let's unpack() create the directory
unpack() {
  local src=$1
  local out=$2
  local appimageSignature=""
  local appimageType=0

  # https://github.com/AppImage/libappimage/blob/ca8d4b53bed5cbc0f3d0398e30806e0d3adeaaab/src/libappimage/utils/MagicBytesChecker.cpp#L45-L63
  eval "$(r2 "$src" -nn -Nqc "p8j 3 @ 8" |
    jq -r '{appimageSignature: (.[:-1]|implode), appimageType: .[-1]}|
      @sh "appimageSignature=\(.appimageSignature) appimageType=\(.appimageType)"')"

  # check AppImage signature
  if [[ "$appimageSignature" != "AI" ]]; then
    echo "Not an appimage."
    exit
  fi

  case "$appimageType" in
    1 ) echo "Uncompress $(basename "$src") of type $appimageType."
        mkdir "$out"
        pv "$src" | bsdtar -x -C "$out" -f -
        ;;
    2)
        # This method avoid issues with non executable appimages,
        # non-native packer, packer patching and squashfs-root destination prefix.

        # multiarch offset one-liner using same method as AppImage
        # see https://gist.github.com/probonopd/a490ba3401b5ef7b881d5e603fa20c93
        offset=$(r2 "$src" -nn -Nqc "pfj.elf_header @ 0" |\
          jq 'map({(.name): .value}) | add | .shoff + (.shnum * .shentsize)')

        echo "Uncompress $(basename "$src") of type $appimageType @ offset $offset."
        unsquashfs -q -d "$out" -o "$offset" "$src"
        chmod go-w "$out"
        ;;

    # 3) get ready, https://github.com/TheAssassin/type3-runtime
    *)  echo Unsupported AppImage Type: "$appimageType"
        exit
        ;;
  esac
  echo "$(basename "$src") is now installed in $out"
}

apprun() {

  eval "$(rahash2 "$APPIMAGE" -j | jq -r '.[] | @sh "SHA256=\(.hash)"')"
  echo sha256 = \""$SHA256"\"\;
  export APPDIR="${XDG_CACHE_HOME:-$HOME/.cache}/appimage-run/$SHA256"

  #compatibility
  if [ -x "$APPDIR/squashfs-root" ]; then APPDIR="$APPDIR/squashfs-root"; fi

  if [ ! -x "$APPDIR" ]; then
    mkdir -p "$(dirname "$APPDIR")"
    unpack "$APPIMAGE" "$APPDIR"
  else echo "$(basename "$APPIMAGE")" installed in "$APPDIR"
  fi

  export PATH="$PATH:$PWD/usr/bin"
}

wrap() {

  cd "$APPDIR" || exit
  # quite same in appimageTools
  export APPIMAGE_SILENT_INSTALL=1

  if [ -n "$APPIMAGE_DEBUG_EXEC" ]; then
    exec "$APPIMAGE_DEBUG_EXEC"
  fi

  exec ./AppRun "$@"
}

usage() {
  cat <<EOF
Usage: appimage-run [appimage-run options] <AppImage> [AppImage options]

-h      show this message
-d      debug mode
-x      <directory> : extract appimage in the directory then exit.
-w      <directory> : run uncompressed appimage directory (used in appimageTools)

[AppImage options]: Options are passed on to the appimage.
If you want to execute a custom command in the appimage's environment, set the APPIMAGE_DEBUG_EXEC environment variable.

EOF
  exit 1
}

while getopts "x:w:dh" option; do
    case "${option}" in
        d)  set -x
            ;;
        x)  # eXtract
            unpack_opt=true
            APPDIR=${OPTARG}
            ;;
        w)  # WrapAppImage
            export APPDIR=${OPTARG}
            wrap_opt=true
            ;;
        h)  usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [[ $wrap_opt = true ]] && [[ -d "$APPDIR" ]]; then
  wrap "$@"
  exit
else
  APPIMAGE="$(realpath "$1")" || usage
  shift
fi

if [[ $unpack_opt = true ]] && [[ -f "$APPIMAGE" ]]; then
  unpack "$APPIMAGE" "$APPDIR"
  exit
fi

if [[ $apprun_opt = true ]] && [[ -f "$APPIMAGE" ]]; then
  apprun
  wrap "$@"
  exit
fi
