{
  lib,
  stdenv,
  fetchFromGitLab,
  SDL2,
  SDL2_image,
  pkg-config,
  libvorbis,
  libGL,
  boost,
  cmake,
  zlib,
  curl,
  SDL2_mixer,
  SDL2_ttf,
  python3,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "commandergenius";
  version = "3.6.4";

  src = fetchFromGitLab {
    owner = "Dringgstein";
    repo = "Commander-Genius";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pjSWAr3qYLWEwwu/ocXbB1smfPsJ7NAtbForPHenN9Q=";
  };

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    libGL
    boost
    libvorbis
    zlib
    curl
    python3
    libx11
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DSHAREDIR=${placeholder "out"}/share"
  ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  postPatch = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(sdl2-config --cflags)"
    sed -i 's,APPDIR games,APPDIR bin,' src/install.cmake
  '';

  meta = {
    description = "Modern Interpreter for the Commander Keen Games";
    longDescription = ''
      Commander Genius is an open-source clone of
      Commander Keen which allows you to play
      the games, and some of the mods
      made for it. All of the original data files
      are required to do so
    '';
    homepage = "https://github.com/gerstrong/Commander-Genius";
    maintainers = with lib.maintainers; [ hce ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
