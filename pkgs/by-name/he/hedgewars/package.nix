{
  stdenv,
  SDL2_image,
  SDL2_ttf,
  SDL2_net,
  fpc,
  haskell,
  ffmpeg,
  libglut,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  lua5_1,
  SDL2,
  SDL2_mixer,
  zlib,
  libpng,
  libGL,
  libGLU,
  physfs,
  qt5,
  withServer ? true,
}:

let
  inherit (qt5) qtbase qttools wrapQtAppsHook;

  ghc = haskell.packages.ghc94.ghcWithPackages (
    pkgs: with pkgs; [
      SHA
      bytestring
      entropy
      hslogger
      network
      pkgs.zlib
      random
      regex-tdfa
      sandi
      utf8-string
      vector
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hedgewars";
  version = "1.0.3";

  src = fetchurl {
    url = "https://hedgewars.org/download/releases/hedgewars-src-${finalAttrs.version}.tar.bz2";
    hash = "sha256-xcGHfAuuE1THXSuVJ7b5qfeemZMuXQix9vfeFwgGYTA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2_ttf
    SDL2_net
    SDL2
    SDL2_mixer
    SDL2_image
    fpc
    lua5_1
    ffmpeg
    libglut
    physfs
    qtbase
  ]
  ++ lib.optional withServer ghc;

  cmakeFlags = [
    "-DNOVERSIONINFOUPDATE=ON"
    "-DNOSERVER=${if withServer then "OFF" else "ON"}"
  ];

  NIX_LDFLAGS = lib.concatMapStringsSep " " (e: "-rpath ${e}/lib") [
    SDL2.out
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    libGL
    libGLU
    libpng.out
    lua5_1
    physfs
    zlib.out
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libGL
        libGLU
        libglut
        physfs
      ]
    }"
  ];

  meta = {
    description = "Funny turn-based artillery game, featuring fighting hedgehogs";
    homepage = "https://hedgewars.org/";
    license = with lib.licenses; [
      gpl2Only

      # Assets
      fdl12Only

      # Fonts
      bitstreamVera
      asl20
    ];
    longDescription = ''
      Each player controls a team of several hedgehogs. During the course of
      the game, players take turns with one of their hedgehogs. They then use
      whatever tools and weapons are available to attack and kill the
      opponents' hedgehogs, thereby winning the game. Hedgehogs may move
      around the terrain in a variety of ways, normally by walking and jumping
      but also by using particular tools such as the "Rope" or "Parachute", to
      move to otherwise inaccessible areas. Each turn is time-limited to
      ensure that players do not hold up the game with excessive thinking or
      moving.

      A large variety of tools and weapons are available for players during
      the game: Grenade, Cluster Bomb, Bazooka, UFO, Homing Bee, Shotgun,
      Desert Eagle, Fire Punch, Baseball Bat, Dynamite, Mine, Rope, Pneumatic
      pick, Parachute. Most weapons, when used, cause explosions that deform
      the terrain, removing circular chunks. The landscape is an island
      floating on a body of water, or a restricted cave with water at the
      bottom. A hedgehog dies when it enters the water (either by falling off
      the island, or through a hole in the bottom of it), it is thrown off
      either side of the arena or when its health is reduced, typically from
      contact with explosions, to zero (the damage dealt to the attacked
      hedgehog or hedgehogs after a player's or CPU turn is shown only when
      all movement on the battlefield has ceased).'';
    maintainers = with lib.maintainers; [
      kragniz
      fpletz
    ];
    platforms = lib.platforms.linux;
  };
})
