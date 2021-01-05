{ stdenv
, fetchFromGitHub
, pkg-config
, cmake
, alsaLib
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

let
  pname = "qmplay2";
  version = "20.12.16";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zaps166";
    repo = "QMPlay2";
    rev = version;
    sha256 = "sha256-+XXlQI9MyENioYmzqbbZYQ6kaMATBjPrPaErR2Vqhus=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [
    alsaLib
    ffmpeg
    libass
    libcddb
    libcdio
    libgme
    libpulseaudio
    libsidplayfp
    libva
    libXv
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

  meta = with stdenv.lib; {
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
