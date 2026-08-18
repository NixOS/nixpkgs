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
  openldap,
}:

stdenv.mkDerivation rec {
  pname = "outfox";
  version = "0.5.0-pre043";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://github.com/TeamRizu/OutFox/releases/download/OF5.0.0-043/OutFox-alpha-0.5.0-pre-043-Final-24.04-amd64-current-date-20250907.tar.gz";
        hash = "sha256-1YN3YCcSluHBUpNRQdh0pJ9R9hTHKBuTSULTKL28OO0=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/TeamRizu/OutFox/releases/download/OF5.0.0-043/OutFox-alpha-0.5.0-pre-043-Final-RaspberryPi-debian12-arm64-aarch64-current-date-20250927.tar.gz";
        hash = "sha256-/E4Keh1J3iytqaq0ziJy9F1mRR3mPbjlGto1Dbct3JM=";
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
    openldap
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

  meta = {
    description = "Rhythm game engine forked from StepMania";
    homepage = "https://projectoutfox.com";
    changelog = "https://github.com/TeamRizu/OutFox/releases/tag/OF5.0.0-043";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ maxwell-lt ];
    mainProgram = "OutFox";
  };
}
