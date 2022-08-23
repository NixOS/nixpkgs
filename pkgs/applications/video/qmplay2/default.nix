{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, alsa-lib
, ffmpeg
, libass
, libcddb
, libcdio
, libgme
, libpulseaudio
, libsidplayfp
, libva
, libXv
, taglib
, qtbase
, qttools
, vulkan-headers
, vulkan-tools
, wrapQtAppsHook
}:
stdenv.mkDerivation rec {
  pname = "qmplay2";
  version = "22.06.16";

  src = fetchFromGitHub {
    owner = "zaps166";
    repo = "QMPlay2";
    rev = version;
    sha256 = "sha256-nSlmbBCfN+yZlCcgTujBSkZc1uOO0wYpMPUwgLudJEY=";
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
    libXv
    libass
    libcddb
    libcdio
    libgme
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

  meta = with lib; {
    homepage = "https://github.com/zaps166/QMPlay2/";
    description = "Qt-based Multimedia player";
    longDescription = ''
      QMPlay2 is a video and audio player. It can play all formats supported by
      FFmpeg, libmodplug (including J2B and SFX). It also supports Audio CD, raw
      files, Rayman 2 music and chiptunes. It contains YouTube and MyFreeMP3
      browser.
    '';
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
