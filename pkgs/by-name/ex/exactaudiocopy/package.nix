{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  imagemagick,
  _7zz,
  wine,
  writeShellScriptBin,
  symlinkJoin,
  use64 ? false,
}:

let
  pname = "exact-audio-copy";
  version = "1.8.0";

  eac_exe = fetchurl {
    urls = [
      "https://www.exactaudiocopy.de/eac-1.8.exe"
      "https://web.archive.org/web/20251231130418/https://www.exactaudiocopy.de/eac-1.8.exe"
    ];
    hash = "sha256-IFUwz7/f+CNDhY84sOcJ5YYFH7iQDs1RPXmSo8HvAxs=";
  };

  cygwin = fetchurl {
    urls = [
      "https://mirrors.kernel.org/sourceware/cygwin/x86_64/release/cygwin/cygwin-3.6.6-1-x86_64.tar.xz"
      "https://web.archive.org/web/20260113125803/https://mirrors.kernel.org/sourceware/cygwin/x86_64/release/cygwin/cygwin-3.6.6-1-x86_64.tar.xz"
    ];
    hash = "sha256-xcgYjfVB9dF0twGC1ww7r4NCPHT/+aEk1CMmS7ndJuA=";
  };

  patched_eac = stdenv.mkDerivation {
    pname = "patched_eac";
    inherit version;

    nativeBuildInputs = [
      imagemagick
      _7zz
    ];

    buildCommand = ''
      mkdir -p $out
      _tmp=$(mktemp -d)
      cd $_tmp
      7zz x -aoa ${eac_exe}
      chmod -R 755 .
      cp ${cygwin} cygwin1.tar.xz
      tar xf cygwin1.tar.xz
      mv usr/bin/cygwin1.dll CDRDAO/
      rm -rf usr
      rm cygwin1.tar.xz
      cp -r * $out
      7zz x EAC.exe
      magick .rsrc/1033/ICON/29.ico -thumbnail 128x128 -alpha on -background none -flatten "$out/eac.ico.128.png"
    '';
  };

  wrapper = writeShellScriptBin pname ''
    export WINEPREFIX="''${EXACT_AUDIO_COPY_HOME:-"''${XDG_DATA_HOME:-"''${HOME}/.local/share"}/exact-audio-copy"}/wine"
    export WINEARCH=${if use64 then "win64" else "win32"}
    export WINEDLLOVERRIDES="mscoree=" # disable mono
    export WINEDEBUG=-all
    if [ ! -d "$WINEPREFIX" ] ; then
      mkdir -p "$WINEPREFIX"
      ${wine}/bin/wineboot -u
    fi

    exec ${wine}/bin/wine ${patched_eac}/EAC.exe "$@"
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    comment = "Audio Grabber for CDs";
    desktopName = "Exact Audio Copy";
    categories = [
      "Audio"
      "AudioVideo"
    ];
    icon = "${patched_eac}/eac.ico.128.png";
  };
in
symlinkJoin {
  name = "${pname}-${version}";

  paths = [
    wrapper
    desktopItem
  ];

  meta = {
    description = "Precise CD audio grabber for creating perfect quality rips using CD and DVD drives";
    homepage = "https://www.exactaudiocopy.de/";
    changelog = "https://www.exactaudiocopy.de/en/index.php/resources/whats-new/whats-new/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.brendanreis ];
    platforms = wine.meta.platforms;
  };
}
