{
  lib,
  alsa-lib,
  callPackage,
  cmake,
  ffmpeg,
  fribidi,
  game-music-emu,
  libXdmcp,
  libXv,
  libass,
  libcddb,
  libcdio,
  libpulseaudio,
  libsidplayfp,
  libva,
  libxcb,
  ninja,
  pkg-config,
  qt5,
  qt6,
  stdenv,
  taglib,
  vulkan-headers,
  vulkan-tools,
  # Configurable options
  qtVersion ? "6" # Can be 5 or 6
}:

let
  sources = callPackage ./sources.nix { };
in
assert lib.elem qtVersion [ "5" "6" ];
stdenv.mkDerivation (finalAttrs: {
  pname = sources.qmplay2.pname + "-qt" + qtVersion;
  inherit (sources.qmplay2) version src;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ]
  ++ lib.optionals (qtVersion == "6") [
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals (qtVersion == "5") [
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    ffmpeg
    fribidi
    game-music-emu
    libXdmcp
    libXv
    libass
    libcddb
    libcdio
    libpulseaudio
    libsidplayfp
    libva
    libxcb
    taglib
    vulkan-headers
    vulkan-tools
  ]
  ++ lib.optionals (qtVersion == "6") [
    qt6.qt5compat
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
  ]
  ++ lib.optionals (qtVersion == "5") [
    qt5.qtbase
    qt5.qttools
  ];

  # Because we think it is better to use only lowercase letters!
  # But sometimes we come across case-insensitive filesystems...
  postFixup = ''
    [ -e $out/bin/qmplay2 ] || ln -s $out/bin/QMPlay2 $out/bin/qmplay2
  '';

  meta = {
    homepage = "https://github.com/zaps166/QMPlay2/";
    description = "Qt-based Multimedia player";
    longDescription = ''
      QMPlay2 is a video and audio player. It can play all formats supported by
      FFmpeg, libmodplug (including J2B and SFX). It also supports Audio CD, raw
      files, Rayman 2 music and chiptunes. It contains YouTube and MyFreeMP3
      browser.
    '';
    changelog = "https://github.com/zaps166/QMPlay2/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    mainProgram = "qmplay2";
    maintainers = with lib.maintainers; [ AndersonTorres kashw2 ];
    platforms = lib.platforms.linux;
  };
})
