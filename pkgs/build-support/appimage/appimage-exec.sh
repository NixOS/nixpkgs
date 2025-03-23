#!@runtimeShell@
# shellcheck shell=bash

if [ -n "$DEBUG" ] ; then
  set -x
fi

PATH="@path@:$PATH"
apprun_opt=true
OWD=$(readlink -f .)
# can be read by appimages: https://docs.appimage.org/packaging-guide/environment-variables.html
export OWD
export APPIMAGE

# src : AppImage
# dest : let's unpack() create the directory
unpack() {
  local src="$1"
  local out="$2"

  # https://github.com/AppImage/libappimage/blob/ca8d4b53bed5cbc0f3d0398e30806e0d3adeaaab/src/libappimage/utils/MagicBytesChecker.cpp#L45-L63
  local appimageSignature;
  appimageSignature="$(LC_ALL=C readelf -h "$src" | awk 'NR==2{print $10$11;}')"
  local appimageType;
  appimageType="$(LC_ALL=C readelf -h "$src" | awk 'NR==2{print $12;}')"

  # check AppImage signature
  if [ "$appimageSignature" != "4149" ]; then
    echo "Not an AppImage file"
    exit
  fi

  case "$appimageType" in
    "01")
      echo "Uncompress $(basename "$src") of type $appimageType"
      mkdir "$out"
      pv "$src" | bsdtar -x -C "$out" -f -
      ;;

    "02")
      # This method avoid issues with non executable appimages,
      # non-native packer, packer patching and squashfs-root destination prefix.

      # multiarch offset one-liner using same method as AppImage
      # see https://gist.github.com/probonopd/a490ba3401b5ef7b881d5e603fa20c93
      offset=$(LC_ALL=C readelf -h "$src" | awk 'NR==13{e_shoff=$5} NR==18{e_shentsize=$5} NR==19{e_shnum=$5} END{print e_shoff+e_shentsize*e_shnum}')
      echo "Uncompress $(basename "$src") of type $appimageType @ offset $offset"
      unsquashfs -q -d "$out" -o "$offset" "$src"
      chmod go-w "$out"
      ;;

    # "03")
    #   get ready, https://github.com/TheAssassin/type3-runtime

    *)
      echo Unsupported AppImage Type: "$appimageType"
      exit
      ;;
  esac
  echo "$(basename "$src") is now installed in $out"
}

apprun() {

  SHA256=$(sha256sum "$APPIMAGE" | awk '{print $1}')
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

  # quite same in appimageTools
  export APPIMAGE_SILENT_INSTALL=1

  if [ -n "$APPIMAGE_DEBUG_EXEC" ]; then
    cd "$APPDIR" || true
    exec "$APPIMAGE_DEBUG_EXEC"
  fi

  exec "$APPDIR/AppRun" "$@"
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
    *)  usage
        ;;
  esac
done
shift "$((OPTIND-1))"

if [ -n "$wrap_opt" ] && [ -d "$APPDIR" ]; then
  wrap "$@"
  exit
else
  APPIMAGE="$(realpath "$1")" || usage
  shift
fi

if [ -n "$unpack_opt" ] && [ -f "$APPIMAGE" ]; then
  unpack "$APPIMAGE" "$APPDIR"
  exit
fi

if [ -n "$apprun_opt" ] && [ -f "$APPIMAGE" ]; then
  apprun
  wrap "$@"
  exit
fi
