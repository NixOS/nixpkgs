{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
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
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "commandergenius";
  version = "3.5.2";

  src = fetchFromGitLab {
    owner = "Dringgstein";
    repo = "Commander-Genius";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4WfHdgn8frcDVa3Va6vo/jZihf09vIs+bNdAxScgovE=";
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
    xorg.libX11
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

  patches = [
    # Fixes a broken build due to a renamed inner struct of SDL_ttf.
    # Should be removable as soon as upstream releases v. 3.5.3.
    (fetchpatch {
      name = "fix-sdl-ttf_font_rename.patch";
      url = "https://github.com/gerstrong/Commander-Genius/commit/e8af0d16970d75e94392f57de0992dfddc509bc3.patch";
      hash = "sha256-bcCzXzh9yDngwHMfQTrnvyDal4YBiBcMTtKTgt9BtDk=";
    })
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
