#!@shell@
if [ ! -z "$DEBUG" ] ; then
  set -x
fi

export PATH=@path@

# src : AppImage
# dest : let's unpack() create the directory
unpack() {
  src=$1
  out=$2

  # https://github.com/AppImage/libappimage/blob/ca8d4b53bed5cbc0f3d0398e30806e0d3adeaaab/src/libappimage/utils/MagicBytesChecker.cpp#L45-L63
  eval "$(r2 "$src" -nn -Nqc "p8j 3 @ 8" |
    jq -r '{appimageSignature: (.[:-1]|implode), appimageType: .[-1]}|
      @sh "appimageSignature=\(.appimageSignature) appimageType=\(.appimageType)"')"

  # check AppImage signature
  if [[ "$appimageSignature" != "AI" ]]; then
    echo "Not an appimage."
    exit -1
  fi

  case "$appimageType" in
    1)  echo "Uncompress $(basename "$src") of Type: $appimageType."
        mkdir "$out"
        pv "$src" | bsdtar -x -C "$out" -f -
        ;;

    2)  echo "Uncompress $(basename "$src") of Type: $appimageType."
        # This method avoid issues with non executable appimages,
        # non-native packer, packer patching and squashfs-root destination prefix.

        # multiarch offset one-liner using same method as AppImage
        # see https://gist.github.com/probonopd/a490ba3401b5ef7b881d5e603fa20c93
        offset=$(r2 "$src" -nn -Nqc "pfj.elf_header @ 0" |\
          jq 'map({(.name): .value}) | add | .shoff + (.shnum * .shentsize)')

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
  echo sha256 = \"$SHA256\"\;
  export APPDIR="${XDG_CACHE_HOME:-$HOME/.cache}/appimage-run/$SHA256"

  #compatibility
  if [ -x "$APPDIR/squashfs-root" ]; then APPDIR="$APPDIR/squashfs-root"; fi

  if [ ! -x "$APPDIR" ]; then
    mkdir -p $(dirname "$APPDIR")
    unpack "$APPIMAGE" "$APPDIR"
  fi

  echo $(basename "$APPIMAGE") installed in "$APPDIR"

  export PATH="$PATH:$PWD/usr/bin"
  wrap
}

wrap() {

  cd "$APPDIR"
  # quite same in appimageTools
  export APPIMAGE_SILENT_INSTALL=1

  if [ -n "$APPIMAGE_DEBUG_EXEC" ]; then
    exec "$APPIMAGE_DEBUG_EXEC"
  fi

  exec ./AppRun "$@"
}

usage() {
  echo "Usage: appimage-run [appimage-run options] <AppImage> [AppImage options]";
  echo
  echo 'Options are passed on to the appimage.'
  echo "If you want to execute a custom command in the appimage's environment, set the APPIMAGE_DEBUG_EXEC environment variable."
  exit 1
}

while getopts ":a:d:xrw" option; do
    case "${option}" in
        a)  #AppImage file
            # why realpath?
            APPIMAGE="$(realpath "${OPTARG}")"
            ;;
        d)  #appimage Directory
            export APPDIR=${OPTARG}
            ;;
        x)  # eXtract
            unpack_opt=true
            ;;
        r)  # appimage-Run
            apprun_opt=true
            ;;
        w)  # WrapAppImage
            wrap_opt=true
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [[ $unpack_opt = true ]] && [[ -f "$APPIMAGE" ]]; then
  unpack "$APPIMAGE" "$APPDIR"
  exit
fi

if [[ $apprun_opt = true ]] && [[ -f "$APPIMAGE" ]]; then
  apprun
fi

if [[ $wrap_opt = true ]] && [[ -d "$APPDIR" ]]; then
  wrap
fi
