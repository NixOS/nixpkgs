{
  lib,
  flutter332,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitLab,
  alsa-lib,
  mpv,
  libass,
  ffmpeg,
  zxing-cpp,
  libplacebo,
  libunwind,
  shaderc,
  vulkan-loader,
  lcms2,
  libdovi,
  libdvdnav,
  libdvdread,
  mujs,
  libbluray,
  lua,
  rubberband,
  libuchardet,
  zimg,
  openal,
  pipewire,
  libpulseaudio,
  libcaca,
  libdrm,
  libdisplay-info,
  libgbm,
  libxscrnsaver,
  libxpresent,
  nv-codec-headers-12,
  libva,
  libvdpau,
}:

flutter332.buildFlutterApplication rec {
  pname = "polycule";
  version = "0.3.4";

  src = fetchFromGitLab {
    owner = "polycule_client";
    repo = "polycule";
    tag = "v${version}";
    hash = "sha256-RUu8DKuX2NUU5Ce5WLHtDaORkn7CSrgTj3KhM/z+yHc=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./gitHashes.json;

  buildInputs = [
    alsa-lib
    mpv
    libass
    zxing-cpp
    ffmpeg
    libplacebo
    libunwind
    shaderc
    vulkan-loader
    lcms2
    libdovi
    libdvdnav
    libdvdread
    mujs
    libbluray
    lua
    rubberband
    libuchardet
    zimg
    openal
    pipewire
    libpulseaudio
    libcaca
    libdrm
    libdisplay-info
    libgbm
    libxscrnsaver
    libxpresent
    nv-codec-headers-12
    libva
    libvdpau
  ]
  ++ mpv.buildInputs;

  postInstall = ''
    install -m 444 -D linux/business.braid.polycule.desktop $out/share/applications/business.braid.polycule.desktop
    install -m 444 -D assets/logo/logo-circle.svg $out/share/pixmaps/business.braid.polycule.svg
    install -m 444 -D assets/logo/logo-circle.svg $out/share/icons/hicolor/scalable/apps/business.braid.polycule.desktop
  '';

  meta = {
    description = "A geeky and efficient [matrix] client for power users";
    homepage = "https://github.com/markomijic/TTS-Mod-Vault";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ tmarkus ];
    # mainProgram = "tts-mod-vault";
    platforms = lib.platforms.linux;
  };
}
