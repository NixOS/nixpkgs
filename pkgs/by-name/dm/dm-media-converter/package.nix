{
  autoPatchelfHook,
  fetchurl,
  ffmpeg,
  lib,
  libqt5pas,
  libX11,
  makeDesktopItem,
  numactl,
  qtbase,
  stdenv,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "dm-media-converter";
  version = "2.5.5";

  src = fetchurl {
    url = "https://drive.usercontent.google.com/download?id=1xBg3mCfvl8TlB4CyacD8YQN0CvHcdn7I&export=download&confirm=t";
    sha256 = "sha256-Jn/Zf5fKIzKjP7GoMuOFq4QlG29azcoEAT/qySAofLA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapQtAppsHook
  ];

  buildInputs = [
    libqt5pas
    libX11
    ffmpeg
    qtbase
    numactl
  ];

  sourceRoot = ".";

  unpackCmd = "tar -xzf $src --strip-components=1";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/bin/bin/x86_64-linux
    mkdir -p "$out"/share/pixmaps

    mv dmMediaConverter "$out"/bin
    mv dmMediaConverter_logo.png "$out"/share/pixmaps/dm-media-converter.png

    ln -s "${lib.getExe ffmpeg}" "$out"/bin/bin/x86_64-linux/ffmpeg
    ln -s "${lib.getExe ffmpeg}" "$out"/bin/bin/x86_64-linux/ffmpeg.mfx
	  ln -s "${lib.getExe' ffmpeg "ffprobe"}" "$out"/bin/bin/x86_64-linux/ffprobe

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "DM Media Converter";
      desktopName = "DM Media Converter";
      genericName = "DM Media Converter";
      comment = "Cross-platform FFmpeg GUI supporting many common encoding options";
      icon = "dm-media-converter";
      exec = "dmMediaConverter";
      type = "Application";
      categories = [
        "AudioVideo"
        "Video"
      ];
    })
  ];

  meta = with lib; {
    description = "Cross-platform FFmpeg GUI supporting many common encoding options";
    homepage = "https://sites.google.com/site/dmsimpleapps";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ kilgarragh ];
    platforms = [ "x86_64-linux" ];
  };
}
