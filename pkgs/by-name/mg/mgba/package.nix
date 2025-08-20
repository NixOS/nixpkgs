{
  lib,
  SDL2,
  cmake,
  fetchFromGitHub,
  ffmpeg,
  discord-rpc,
  libedit,
  elfutils,
  libepoxy,
  libsForQt5,
  libzip,
  lua,
  minizip,
  pkg-config,
  stdenv,
  wrapGAppsHook3,
  enableDiscordRpc ? false,
}:

let
  inherit (libsForQt5)
    qtbase
    qtmultimedia
    qttools
    wrapQtAppsHook
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mgba";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "mgba-emu";
    repo = "mgba";
    rev = finalAttrs.version;
    hash = "sha256-GATjKpY4EYgep4uquBuaxDsS13aIoxVicAYs/KAs1lE=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "lib"
    "man"
  ];

  nativeBuildInputs = [
    SDL2
    cmake
    pkg-config
    wrapGAppsHook3
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    ffmpeg
    libedit
    elfutils
    libepoxy
    libzip
    lua
    minizip
    qtbase
    qtmultimedia
    qttools
  ] ++ lib.optionals enableDiscordRpc [ discord-rpc ];

  cmakeFlags = [
    (lib.cmakeBool "USE_DISCORD_RPC" enableDiscordRpc)
  ];

  strictDeps = true;

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://mgba.io";
    description = "Modern GBA emulator with a focus on accuracy";
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
    changelog = "https://raw.githubusercontent.com/mgba-emu/mgba/${finalAttrs.src.rev}/CHANGES";
    license = with lib.licenses; [ mpl20 ];
    mainProgram = "mgba";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
    broken = enableDiscordRpc; # Some obscure `ld` error
  };
})
