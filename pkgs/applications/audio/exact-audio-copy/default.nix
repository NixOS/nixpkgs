{ lib
, stdenv
, fetchurl
, makeDesktopItem
, imagemagick
, p7zip
, wine
, writeShellScriptBin
, symlinkJoin
, use64 ? false
}:

let
  pname = "exact-audio-copy";
  version = "1.6.0";

  eac_exe = fetchurl {
    url = "http://www.exactaudiocopy.de/eac-${lib.versions.majorMinor version}.exe";
    sha256 = "8291d33104ebab2619ba8d85744083e241330a286f5bd7d54c7b0eb08f2b84c1";
  };

  cygwin_dll = fetchurl {
    url = "https://cygwin.com/snapshots/x86/cygwin1-20220301.dll.xz";
    sha256 = "0zxn0r5q69fhciy0mrplhxj1hxwy3sq4k1wdy6n6kyassm4zyz1x";
  };

  patched_eac = stdenv.mkDerivation {
    pname = "patched_eac";
    inherit version;

    nativeBuildInputs = [
      imagemagick
      p7zip
    ];

    buildCommand = ''
      mkdir -p $out
      _tmp=$(mktemp -d)
      cd $_tmp
      7z x -aoa ${eac_exe}
      chmod -R 755 .
      cp ${cygwin_dll} cygwin1.dll.xz
      xz --decompress cygwin1.dll.xz
      mv cygwin1.dll CDRDAO/
      cp -r * $out
      7z x EAC.exe
      convert .rsrc/1033/ICON/29.ico -thumbnail 128x128 -alpha on -background none -flatten "$out/eac.ico.128.png"
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
    categories = [ "Audio" "AudioVideo" ];
    icon = "${patched_eac}/eac.ico.128.png";
  };
in
symlinkJoin {
  name = "${pname}-${version}";

  paths = [ wrapper desktopItem ];

  meta = with lib; {
    description = "A precise CD audio grabber for creating perfect quality rips using CD and DVD drives";
    homepage = "https://www.exactaudiocopy.de/";
    changelog = "https://www.exactaudiocopy.de/en/index.php/resources/whats-new/whats-new/";
    license = licenses.unfree;
    maintainers = [ maintainers.brendanreis ];
    platforms = wine.meta.platforms;
  };
}
