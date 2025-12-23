{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  spdlog,
  ffmpeg,
  taglib,
  kdePackages,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "easyaudiosync";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "complexlogic";
    repo = "EasyAudioSync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UCOL4DzynKjNDvS0HZ4/K+Wn5lOqHZ0bNop0zqJl5kc=";
  };

  patches = [
    ./0001-fix-project-name.patch
    ./0003-fix-darwin-app.patch
    ./0004-force-qt6.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux copyDesktopItems;

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qttools
    ffmpeg
    spdlog
    taglib
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv "easyaudiosync.app" "Easy Audio Sync.app"
    cp -r "Easy Audio Sync.app" $out/Applications
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
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

  meta = {
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
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
