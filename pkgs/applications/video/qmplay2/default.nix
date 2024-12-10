{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
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
  pkg-config,
  qtbase,
  qttools,
  taglib,
  vulkan-headers,
  vulkan-tools,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmplay2";
  version = "24.04.07";

  src = fetchFromGitHub {
    owner = "zaps166";
    repo = "QMPlay2";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-WIDGApvl+aaB3Vdv0sHY+FHWqzreWWd3/xOLV11YfxM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
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
    qtbase
    qttools
    taglib
    vulkan-headers
    vulkan-tools
  ];

  postInstall = ''
    # Because we think it is better to use only lowercase letters!
    ln -s $out/bin/QMPlay2 $out/bin/qmplay2
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
    maintainers = with lib.maintainers; [
      AndersonTorres
      kashw2
    ];
    platforms = lib.platforms.linux;
  };
})
