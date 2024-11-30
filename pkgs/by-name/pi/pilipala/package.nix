{
  autoPatchelfHook,
  lib,
  fetchFromGitHub,
  flutter319,
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
flutter319.buildFlutterApplication rec {
  pname = "pilipala";
  version = "1.0.24-unstable-2024-11-13";

  src = fetchFromGitHub {
    owner = "guozhigq";
    repo = "pilipala";
    rev = "f7a164de7629b4c285edc38cb9e33971bd275c5c";
    hash = "sha256-+B7JOmbzI8HmaxneRxM/h3vAq9/woHIuh356FPFy3SE=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  desktopItems = [
    (makeDesktopItem {
      name = "pilipala";
      exec = "pilipala";
      icon = "pilipala";
      genericName = "PiliPala";
      desktopName = "PiliPala";
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
    floating = "sha256-2L/7XPnebLt5hnL7IYlYEjaOt4IQpuesK6FDnz7eFeY=";
    media_kit = "sha256-Ehn6ZgNlBSinNAPvopuiOqn5ypRdqlnj8O2jzJGSSeM=";
    media_kit_libs_video = "sha256-Ehn6ZgNlBSinNAPvopuiOqn5ypRdqlnj8O2jzJGSSeM=";
    media_kit_video = "sha256-Ehn6ZgNlBSinNAPvopuiOqn5ypRdqlnj8O2jzJGSSeM=";
    ns_danmaku = "sha256-Xucxzmdyv09QsQ6s3JOdfNuqJvtgzGf/p1AN22iyXrU=";
  };

  postInstall = ''
    install -Dm644 ./assets/images/logo/logo_android_2.png $out/share/pixmaps/pilipala.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : "$out/app/${pname}/lib"
  '';

  meta = {
    description = "Third-party BiliBili client developed with Flutter";
    homepage = "https://github.com/guozhigq/pilipala";
    mainProgram = "pilipala";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
