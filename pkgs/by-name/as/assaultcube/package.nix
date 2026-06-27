{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
  openal,
  pkg-config,
  libogg,
  libvorbis,
  SDL2,
  SDL2_image,
  libGL,
  libx11,
  makeWrapper,
  zlib,
  client ? true,
  server ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "assaultcube";
  version = "1.3.0.2";

  src = fetchFromGitHub {
    owner = "assaultcube";
    repo = "AC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6UfOKgI+6rMGNHlRQnVCm/zD3wCKwbeOD7jgxH8aY2M=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    zlib
  ]
  # On Darwin, even the server needs SDL2 (AC uses SDL threads/timers via __APPLE__)
  ++ lib.optionals (client || stdenv.hostPlatform.isDarwin) [
    SDL2
  ]
  ++ lib.optionals client [
    openal
    SDL2_image
    libogg
    libvorbis
  ]
  ++ lib.optionals (client && !stdenv.hostPlatform.isDarwin) [
    libGL
    libx11
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2}/include/SDL2";
  };

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace source/src/Makefile \
      --replace-fail '-lX11' ''' \
      --replace-fail '-lGL' '-framework OpenGL' \
      --replace-fail '-lrt' '-lSDL2'

    mkdir -p source/include/OpenAL source/include/Vorbis
    ln -sf ${lib.getDev openal}/include/AL/al.h source/include/OpenAL/al.h
    ln -sf ${lib.getDev openal}/include/AL/alc.h source/include/OpenAL/alc.h
    ln -sf ${lib.getDev libvorbis}/include/vorbis/vorbisfile.h source/include/Vorbis/vorbisfile.h
  '';

  makeFlags = [
    "-C source/src"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ]
  ++ lib.optionals server [ "server" ]
  ++ lib.optionals client [ "client" ];

  desktopItems = [
    (makeDesktopItem {
      name = "assaultcube";
      desktopName = "AssaultCube";
      comment = "A multiplayer, first-person shooter game, based on the CUBE engine. Fast, arcade gameplay.";
      genericName = "First-person shooter";
      categories = [
        "Game"
        "ActionGame"
        "Shooter"
      ];
      icon = "assaultcube";
      exec = "assaultcube";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/games/assaultcube

    cp -r config packages $out/share/games/assaultcube

    cp source/src/ac_client $out/bin
    install -Dpm644 packages/misc/icon.png \
      $out/share/icons/hicolor/32x32/apps/assaultcube.png

    makeWrapper $out/bin/ac_client $out/bin/assaultcube \
      --chdir "$out/share/games/assaultcube" \
      --add-flags "--home=\$HOME/.assaultcube/v1.2next --init"

    cp source/src/ac_server $out/bin
    makeWrapper $out/bin/ac_server $out/bin/assaultcube-server \
      --chdir "$out/share/games/assaultcube" \
      --add-flags "-Cconfig/servercmdline.txt"

    runHook postInstall
  '';

  meta = {
    description = "Fast and fun first-person-shooter based on the Cube fps";
    homepage = "https://assault.cubers.net";
    platforms = lib.platforms.all;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ darkonion0 ];
  };
})
