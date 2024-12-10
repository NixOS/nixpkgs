{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  alsa-lib,
  freetype,
  libjack2,
  libglvnd,
  libpulseaudio,
  makeDesktopItem,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "outfox";
  version = "0.5.0-pre042";

  src =
    {
      i686-linux = fetchurl {
        url = "https://github.com/TeamRizu/OutFox/releases/download/OF5.0.0-042/OutFox-alpha-0.5.0-pre042-Linux-14.04-32bit-i386-i386-legacy-date-20231227.tar.gz";
        sha256 = "sha256-NFjNoqJ7Fq4A7Y0k6oQcWjykV+/b/MiRtJ1p6qlZdjs=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/TeamRizu/OutFox/releases/download/OF5.0.0-042/OutFox-alpha-0.5.0-pre042-Linux-22.04-amd64-current-date-20231224.tar.gz";
        hash = "sha256-dW+g/JYav3rUuI+nHDi6rXu/O5KYiEdk/HH82jgOUnI=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/TeamRizu/OutFox/releases/download/OF5.0.0-042/OutFox-alpha-0.5.0-pre042-Raspberry-Pi-Linux-18.04-arm64-arm64v8-modern-date-20231225.tar.gz";
        hash = "sha256-7Qrq6t8KmUSIK4Rskkxw5l4UZ2vsb9/orzPegHySaJ4=";
      };
      armv7l-linux = fetchurl {
        url = "https://github.com/TeamRizu/OutFox/releases/download/OF5.0.0-042/OutFox-alpha-0.5.0-pre042-Raspberry-Pi-Linux-14.04-arm32-arm32v7-legacy-date-20231227.tar.gz";
        hash = "sha256-PRp7kuqFBRy7nextTCB+/poc+A9AX2EiQphx6aUfT8E=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    freetype
    libjack2
    libglvnd
    libpulseaudio
  ];

  desktop = makeDesktopItem {
    name = "project-outfox";
    desktopName = "Project OutFox";
    genericName = "Rhythm game engine";
    exec = "OutFox";
    tryExec = "OutFox";
    categories = [ "Game" ];
  };

  patchPhase = ''
    find ./Appearance -type f -executable -exec chmod -x {} \;
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/OutFox $out/share/applications
    cp -r ./. $out/share/OutFox
    ln -s ${desktop}/share/applications/project-outfox.desktop $out/share/applications/project-outfox.desktop
    makeWrapper $out/share/OutFox/OutFox $out/bin/OutFox --argv0
  '';

  meta = with lib; {
    description = "A rhythm game engine forked from StepMania";
    homepage = "https://projectoutfox.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "armv7l-linux"
    ];
    maintainers = with maintainers; [ maxwell-lt ];
    mainProgram = "OutFox";
  };
}
