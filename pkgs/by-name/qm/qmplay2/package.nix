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
  pkg-config,
  qt5,
  stdenv,
  taglib,
  vulkan-headers,
  vulkan-tools,
}:

let
  sources = callPackage ./sources.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  inherit (sources.qmplay2) pname version src;

  postPatch = ''
    pushd src
    cp -va ${sources.qmvk.src}/* qmvk/
    chmod --recursive 744 qmvk
    popd
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ [
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
  ++ [
    qt5.qtbase
    qt5.qttools
  ];

  strictDeps = true;

  # Because we think it is better to use only lowercase letters!
  # But sometimes we come across case-insensitive filesystems...
  postInstall = ''
    [ -e $out/bin/qmplay2 ] || ln -s $out/bin/QMPlay2 $out/bin/qmplay2
  '';

  passthru = {
    inherit sources;
  };

  meta = {
    homepage = "https://github.com/zaps166/QMPlay2/";
    description = "Qt-based Multimedia player";
    longDescription = ''
      QMPlay2 is a video and audio player. It can play all formats supported by
      FFmpeg, libmodplug (including J2B and SFX). It also supports Audio CD, raw
      files, Rayman 2 music and chiptunes. It contains YouTube and MyFreeMP3
      browser.
    '';
    license = lib.licenses.lgpl3Plus;
    mainProgram = "qmplay2";
    maintainers = with lib.maintainers; [ AndersonTorres kashw2 ];
    platforms = lib.platforms.linux;
  };
})
