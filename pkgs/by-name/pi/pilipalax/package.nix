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
  mesa,
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
  pname = "pilipalax";
  version = "1.0.22-beta.12+174";

  src = fetchFromGitHub {
    owner = "orz12";
    repo = "PiliPalaX";
    tag = version;
    hash = "sha256-Qjqyg9y5R70hODGfVClS505dJwexL0BbUm6lXSHzhJs=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  desktopItems = [
    (makeDesktopItem {
      name = "pilipalax";
      exec = "pilipala";
      icon = "pilipalax";
      genericName = "PiliPalaX";
      desktopName = "PiliPalaX";
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
    mesa
    libXScrnSaver
    libXpresent
    nv-codec-headers-11
    libva
    libvdpau
  ];

  gitHashes = {
    ns_danmaku = "sha256-OHlKscybKSLS1Jd1S99rCjHMZfuJXjkQB8U2Tx5iWeA=";
    auto_orientation = "sha256-0QOEW8+0PpBIELmzilZ8+z7ozNRxKgI0BzuBS8c1Fng=";
    mime = "sha256-tqFOH85YTyxtp0LbknScx66CvN4SwYKU6YxYQMNeVs4=";
  };

  postInstall = ''
    install -Dm644 ./assets/images/logo/logo_android_2.png $out/share/pixmaps/pilipalax.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : "$out/app/${pname}/lib"
  '';

  meta = {
    description = "Third-party BiliBili client developed with Flutter";
    homepage = "https://github.com/orz12/PiliPalaX";
    mainProgram = "pilipala";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
