{
  lib,
  copyDesktopItems,
  fetchFromGitHub,
  makeDesktopItem,
  python3,
  kdePackages,
  ffmpeg,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "onthespot";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justin025";
    repo = "onthespot";
    tag = "v${version}";
    hash = "sha256-W/7xfdSCrKrvG5M5IMPQyifjgE4H7t98YS4230HQd9c=";
  };

  build-system = [ python3.pkgs.setuptools ];

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  pythonRemoveDeps = [
    "PyQt5-Qt5"
    "PyQt5-stubs"
    # Doesn't seem to be used in the sources and causes
    # build issues
    "PyOgg"
  ];

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    copyDesktopItems
    kdePackages.wrapQtAppsHook
  ];

  dependencies = with python3.pkgs; [
    async-timeout
    charset-normalizer
    defusedxml
    ffmpeg
    flask
    librespot
    music-tag
    packaging
    pillow
    protobuf
    pyperclip
    pyqt6
    pyqt6-sip
    pyxdg
    qt6.qtbase
    requests
    show-in-file-manager
    urllib3
    yt-dlp
    zeroconf
  ];

  postInstall = ''
    install -Dm444 $src/src/onthespot/resources/icons/onthespot.png $out/share/icons/hicolor/256x256/apps/onthespot.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Onthespot";
      exec = "onthespot_gui";
      icon = "onthespot";
      desktopName = "Onthespot";
      comment = meta.description;
      categories = [ "AudioVideo" ];
    })
  ];

  meta = {
    description = "QT based Spotify music downloader written in Python";
    homepage = "https://github.com/justin025/onthespot";
    changelog = "https://github.com/justin025/onthespot/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      onny
      ryand56
    ];
    platforms = lib.platforms.linux;
    mainProgram = "onthespot_gui";
  };
}
