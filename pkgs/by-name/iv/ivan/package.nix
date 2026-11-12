{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  SDL2,
  SDL2_mixer,
  alsa-lib,
  libpng,
  pcre2,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ivan";
  version = "059-unstable-2026-10-15";

  src = fetchFromGitHub {
    owner = "Attnam";
    repo = "ivan";
    rev = "fd169a587b19f4a53b16f2c7a920113473b2410b";
    hash = "sha256-oNGcySuKzagORChecaXqpyinCt8lKdHSnUWa+Tbflqc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    alsa-lib
    libpng
    pcre2
  ];

  hardeningDisable = [ "all" ];

  # Enable wizard mode
  cmakeFlags = [ "-DCMAKE_CXX_FLAGS=-DWIZARD" ];

  # Help CMake find SDL_mixer.h
  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2_mixer}/include/SDL2";

  # Create "ivan.desktop" file
  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = finalAttrs.pname;
      icon = "ivan";
      desktopName = "IVAN";
      genericName = finalAttrs.pname;
      categories = [
        "Game"
        "AdventureGame"
        "RolePlaying"
      ];
      comment = finalAttrs.meta.description;
    })
  ];

  # Create appropriate directories. Copy icons and desktop item to these directories.
  postInstall = ''
    mkdir -p $out/share/icons/hicolor/16x16/apps
    mkdir -p $out/share/icons/hicolor/32x32/apps
    mkdir -p $out/share/icons/hicolor/128x128/apps
    mkdir -p $out/share/icons/hicolor/256x256/apps
    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp $src/Graphics/icons/shadowless.iconset/icon_16x16.png $out/share/icons/hicolor/16x16/apps/ivan.png
    cp $src/Graphics/icons/shadowless.iconset/icon_32x32.png $out/share/icons/hicolor/32x32/apps/ivan.png
    cp $src/Graphics/icons/shadowless.iconset/icon_128x128.png $out/share/icons/hicolor/128x128/apps/ivan.png
    cp $src/Graphics/icons/shadowless.iconset/icon_256x256.png $out/share/icons/hicolor/256x256/apps/ivan.png
    cp $src/Graphics/icons/shadowless.iconset/icon_512x512.png $out/share/icons/hicolor/512x512/apps/ivan.png
  '';

  meta = {
    description = "Graphical roguelike game";
    longDescription = ''
      Iter Vehemens ad Necem (IVAN) is a graphical roguelike game, which currently
      runs in Windows, DOS, Linux, and OS X. It features advanced bodypart and
      material handling, multi-colored lighting and, above all, deep gameplay.

      This is a fan continuation of IVAN by members of Attnam.com
    '';
    homepage = "https://attnam.com/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "ivan";
  };
})
