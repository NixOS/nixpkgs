{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  autoreconfHook,
  pkg-config,
  SDL2,
  SDL2_mixer,
  SDL2_image,
  libvorbis,
  libjpeg,
  libpng,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "freedroid";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "ReinhardPrix";
    repo = "FreedroidClassic";
    rev = "freedroid-${version}-sdl2-port";
    sha256 = "sha256-4w4d0hJEEZItLZLaujrFDgPDYSZxKz9tkE1S95dnkh8=";
  };

  nativeBuildInputs = [
    SDL2
    pkg-config
    copyDesktopItems
    imagemagick
    autoreconfHook
  ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    libjpeg
    libpng
    libvorbis
    zlib
  ];

  # DOes not build on -std=c23 due to `bool` collision.
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/32x32/apps
    convert graphics/paraicon.bmp $out/share/icons/hicolor/32x32/apps/freedroid.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "Freedroid Classic";
      comment = "A clone of the classic game 'Paradroid' on Commodore 64";
      categories = [
        "Game"
        "ArcadeGame"
      ];
    })
  ];

  meta = {
    description = "Clone of the classic game 'Paradroid' on Commodore 64";
    mainProgram = "freedroid";
    homepage = "https://github.com/ReinhardPrix/FreedroidClassic";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ iblech ];
    platforms = lib.platforms.unix;
    # Builds but fails to render to the screen at runtime.
    broken = stdenv.hostPlatform.isDarwin;
  };
}
