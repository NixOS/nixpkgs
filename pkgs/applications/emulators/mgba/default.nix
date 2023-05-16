{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, ffmpeg
, libedit
, libelf
, libepoxy
, libzip
, lua5_4
, minizip
, pkg-config
, libsForQt5
<<<<<<< HEAD
, wrapGAppsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
    lua = lua5_4;
    inherit (libsForQt5)
      qtbase
      qtmultimedia
      qttools
      wrapQtAppsHook;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mgba";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "mgba-emu";
    repo = "mgba";
    rev = finalAttrs.version;
    hash = "sha256-+AwIYhnqp984Banwb7zmB5yzenExfLLU1oGJSxeTl/M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
<<<<<<< HEAD
    wrapGAppsHook
    wrapQtAppsHook
  ];

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

=======
    wrapQtAppsHook
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    SDL2
    ffmpeg
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
<<<<<<< HEAD
    mainProgram = "mgba";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
})
