{
  autoPatchelfHook,
  lib,
  fetchFromGitHub,
  flutter324,
  mpv,
  libass,
  ffmpeg,
  libplacebo,
  libunwind,
  shaderc,
  vulkan-loader,
  lcms,
  libdovi,
  libdvdnav,
  libdvdread,
  mujs,
  libbluray,
  lua,
  rubberband,
  libuchardet,
  zimg,
  alsa-lib,
  openal,
  pipewire,
  libpulseaudio,
  libcaca,
  libdrm,
  libgbm,
  libXScrnSaver,
  nv-codec-headers-11,
  libXpresent,
  libva,
  libvdpau,
  pkg-config,
  makeDesktopItem,
  wrapGAppsHook3,
  copyDesktopItems,
}:
flutter324.buildFlutterApplication rec {
  pname = "simple-live-app";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "xiaoyaocz";
    repo = "dart_simple_live";
    tag = "v${version}";
    hash = "sha256-0tEvPKYJnPDLvHv873JaRSuhkeXTTK4whnCuYpUK0yo=";
  };

  sourceRoot = "${src.name}/simple_live_app";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  desktopItems = [
    (makeDesktopItem {
      name = "simple-live-app";
      exec = "simple_live_app";
      icon = "simple-live-app";
      genericName = "Simple-Live";
      desktopName = "Simple-Live";
      keywords = [
        "Simple Live"
      ];
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    mpv
    libass
    ffmpeg
    libplacebo
    libunwind
    shaderc
    vulkan-loader
    lcms
    libdovi
    libdvdnav
    libdvdread
    mujs
    libbluray
    lua
    rubberband
    libuchardet
    zimg
    alsa-lib
    openal
    pipewire
    libpulseaudio
    libcaca
    libdrm
    libgbm
    libXScrnSaver
    libXpresent
    nv-codec-headers-11
    libva
    libvdpau
  ];

  gitHashes.ns_danmaku = "sha256-Hzp5QsdgBStaPVSHdHul7ZqOhZHQS9dbO+RpC4wMYqo=";

  postInstall = ''
    install -Dm644 ./assets/logo.png $out/share/pixmaps/simple-live-app.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : "$out/app/simple-live-app/lib"
  '';

  meta = {
    description = "Simply Watch Live";
    homepage = "https://github.com/xiaoyaocz/dart_simple_live";
    mainProgram = "simple_live_app";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
