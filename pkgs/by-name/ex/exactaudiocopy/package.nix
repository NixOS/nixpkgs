{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  imagemagick,
  p7zip,
  wine,
  writeShellScriptBin,
  symlinkJoin,
  use64 ? false,
}:

let
  pname = "exact-audio-copy";
  version = "1.8.0";

  eac_exe = fetchurl {
    url = "http://www.exactaudiocopy.de/eac-${lib.versions.majorMinor version}.exe";
    sha256 = "205530cfbfdff82343858f38b0e709e586051fb8900ecd513d7992a3c1ef031b";
  };

  cygwin = fetchurl {
    url = "https://mirrors.kernel.org/sourceware/cygwin/x86_64/release/cygwin/cygwin-3.6.1-1-x86_64.tar.xz";
    sha256 = "45d1c76a15426209c20a8d4df813e94fbd17bd5d85ad4d742515ff432400143e";
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
      cp ${cygwin} cygwin1.tar.xz
      tar xf cygwin1.tar.xz
      mv usr/bin/cygwin1.dll CDRDAO/
      rm -rf usr
      rm cygwin1.tar.xz
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

  meta = with lib; {
    description = "Precise CD audio grabber for creating perfect quality rips using CD and DVD drives";
    homepage = "https://www.exactaudiocopy.de/";
    changelog = "https://www.exactaudiocopy.de/en/index.php/resources/whats-new/whats-new/";
    license = licenses.unfree;
    maintainers = [ maintainers.brendanreis ];
    platforms = wine.meta.platforms;
  };
}
