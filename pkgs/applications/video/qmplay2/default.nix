{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, cmake
, ffmpeg
, game-music-emu
, libXv
, libass
, libcddb
, libcdio
, libpulseaudio
, libsidplayfp
, libva
, pkg-config
, qtbase
, qttools
, taglib
, vulkan-headers
, vulkan-tools
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmplay2";
  version = "23.02.05";

  src = fetchFromGitHub {
    owner = "zaps166";
    repo = "QMPlay2";
    rev = finalAttrs.version;
    sha256 = "sha256-ZDpUgD9qTvjopGFVrwTBSEmrXn+4aKq2zeqoTnXwmI8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    ffmpeg
    game-music-emu
    libXv
    libass
    libcddb
    libcdio
    libpulseaudio
    libsidplayfp
    libva
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
