{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, ffmpeg_4
, imagemagick
, libedit
, libelf
, libepoxy
, libzip
, lua5_4
, minizip
, pkg-config
, libsForQt5
}:

let
    ffmpeg = ffmpeg_4;
    lua = lua5_4;
    inherit (libsForQt5)
      qtbase
      qtmultimedia
      qttools
      wrapQtAppsHook;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mgba";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "mgba-emu";
    repo = "mgba";
    rev = finalAttrs.version;
    hash = "sha256-2thc2v3aD8t1PrREZIjzRuYfP7b3BA7uFb6R95zxsZI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    ffmpeg
    imagemagick
    libedit
    libelf
    libepoxy
    libzip
    lua
    minizip
    qtbase
    qtmultimedia
    qttools
  ];

  meta = with lib; {
    homepage = "https://mgba.io";
    description = "A modern GBA emulator with a focus on accuracy";
    longDescription = ''
      mGBA is a new Game Boy Advance emulator written in C.

      The project started in April 2013 with the goal of being fast enough to
      run on lower end hardware than other emulators support, without
      sacrificing accuracy or portability. Even in the initial version, games
      generally play without problems. It is loosely based on the previous
      GBA.js emulator, although very little of GBA.js can still be seen in mGBA.

      Other goals include accurate enough emulation to provide a development
      environment for homebrew software, a good workflow for tool-assist
      runners, and a modern feature set for emulators that older emulators may
      not support.
    '';
    changelog = "https://github.com/mgba-emu/mgba/blob/${finalAttrs.version}/CHANGES";
    license = licenses.mpl20;
    maintainers = with maintainers; [ MP2E AndersonTorres ];
    platforms = platforms.linux;
  };
})
