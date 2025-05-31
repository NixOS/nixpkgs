{
  lib,
  stdenv,
  flutter329,
  mpv-unwrapped,
  patchelf,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
}:
let
  version = "0.9.16-beta";
in
flutter329.buildFlutterApplication {
  inherit version;
  pname = "finamp";
  src = fetchFromGitHub {
    owner = "jmshrv";
    repo = "finamp";
    rev = version;
    hash = "sha256-AmxQyDV0AiS2qzAsrgBm0SqH0CaLi3W1A3gcsk65dj0=";
  };
  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    patchelf
    copyDesktopItems
  ];
  buildInputs = [ mpv-unwrapped ];

  gitHashes = {
    balanced_text = "sha256-lSDR5dDjZ4garRbBPI+wSxC5iScg8wVSD5kymmLbYbk=";
    isar_generator = "sha256-EthUFM+YI3bnM0U0sECoNOCRXpo4qjP71VXYBuO/u+I=";
    media_kit_libs_windows_audio = "sha256-p3hRq79whLFJLNUgL9atXyTGvOIqCbTRKVk1ie0Euqs=";
    palette_generator = "sha256-mnRJf3asu1mm9HYU8U0di+qRk3SpNFwN3S5QxChpIA0=";
    split_view = "sha256-unTJQDXUUPVDudlk0ReOPNYrsyEpbd/UMg1tHZsmg+k=";
  };

  postFixup = ''
    patchelf $out/app/$pname/finamp --add-needed libisar.so --add-needed libmpv.so --add-rpath ${
      lib.makeLibraryPath [ mpv-unwrapped ]
    }
  '';

  postInstall = ''
    install -Dm444 assets/icon/icon_foreground.svg $out/share/icons/hicolor/scalable/apps/finamp.svg
    install -Dm444 assets/com.unicornsonlsd.finamp.metainfo.xml -t $out/share/metainfo
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "com.unicornsonlsd.finamp";
      desktopName = "Finamp";
      genericName = "Music Player";
      exec = "finamp";
      icon = "finamp";
      startupWMClass = "finamp";
      comment = "An open source Jellyfin music player";
      categories = [
        "AudioVideo"
        "Audio"
        "Player"
        "Music"
      ];
    })
  ];

  meta = {
    # Finamp depends on `ìsar`, which for Linux is only compiled for x86_64. https://github.com/jmshrv/finamp/issues/766
    broken = stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isx86_64;
    description = "Open source Jellyfin music player";
    homepage = "https://github.com/jmshrv/finamp";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dseelp ];
    mainProgram = "finamp";
    platforms = lib.platforms.linux;
  };
}
