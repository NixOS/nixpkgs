{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, cmake
, ffmpeg
<<<<<<< HEAD
, fribidi
, game-music-emu
, libXdmcp
=======
, game-music-emu
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libXv
, libass
, libcddb
, libcdio
, libpulseaudio
, libsidplayfp
, libva
<<<<<<< HEAD
, libxcb
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "23.08.22";
=======
  version = "23.02.05";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zaps166";
    repo = "QMPlay2";
    rev = finalAttrs.version;
<<<<<<< HEAD
    fetchSubmodules = true;
    hash = "sha256-Ug7WAqZ+BxspQUXweL/OnVBGCsU60DOWNexbi0GpDo0=";
=======
    sha256 = "sha256-ZDpUgD9qTvjopGFVrwTBSEmrXn+4aKq2zeqoTnXwmI8=";
    fetchSubmodules = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    ffmpeg
<<<<<<< HEAD
    fribidi
    game-music-emu
    libXdmcp
=======
    game-music-emu
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libXv
    libass
    libcddb
    libcdio
    libpulseaudio
    libsidplayfp
    libva
<<<<<<< HEAD
    libxcb
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ AndersonTorres kashw2 ];
=======
    maintainers = with lib.maintainers; [ AndersonTorres ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = lib.platforms.linux;
  };
})
