{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  qtbase,
  qttools,
  spdlog,
  ffmpeg,
  taglib,
  wrapQtAppsHook,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "easyaudiosync";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "complexlogic";
    repo = "EasyAudioSync";
    rev = "v${version}";
    hash = "sha256-w98tj9BuixPhuDgwn74EYY0gvKH6kbfQmtg030RWRU0=";
  };

  patches = [
    ./0001-fix-project-name.patch
    ./0002-fix-qt67-deprecated-methods.patch
    ./0003-fix-darwin-app.patch
    ./0004-force-qt6.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ] ++ lib.optional stdenv.isLinux copyDesktopItems;

  buildInputs = [
    qtbase
    qttools
    ffmpeg
    spdlog
    taglib
  ];

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/Applications
      mv "easyaudiosync.app" "Easy Audio Sync.app"
      cp -r "Easy Audio Sync.app" $out/Applications
    ''
    + lib.optionalString stdenv.isLinux ''
      install -Dm755 easyaudiosync $out/bin/easyaudiosync

      for RES in 48 64 128 256; do
        install -Dm755 "$src/assets/icons/easyaudiosync''${RES}.png" "$out/share/icons/hicolor/''${RES}x''${RES}/apps/easyaudiosync.png"
      done

      install -Dm755 "$src/assets/icons/easyaudiosync.svg" "$out/share/icons/hicolor/scalable/apps/easyaudiosync.svg"
    ''
    + ''
      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "easyaudiosync";
      exec = "easyaudiosync";
      icon = "easyaudiosync";
      desktopName = "Easy Audio Sync";
      categories = [
        "Qt"
        "Audio"
        "AudioVideo"
      ];
      comment = "Audio library syncing and conversion utility";
    })
  ];

  meta = with lib; {
    description = "Audio library syncing and conversion utility";
    longDescription = ''
      Easy Audio Sync is an audio library syncing and conversion utility.
      The intended use is syncing an audio library with many lossless files to a mobile device
      with limited storage.

      The program's design is inspired by the rsync utility. It supports folder-based
      source to destination syncing, with added audio transcoding capability, and is
      GUI-based instead of CLI-based.
    '';
    homepage = "https://github.com/complexlogic/EasyAudioSync";
    license = licenses.unlicense;
    maintainers = with maintainers; [ matteopacini ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
