{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  curl,
  SDL2,
  libGLU,
  libGL,
  glew,
  ncurses,
  c-ares,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bzflag";
  version = "2.4.30";

  src = fetchurl {
    url = "https://download.bzflag.org/bzflag/source/${finalAttrs.version}/bzflag-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-u3i3UOe856p8Eb01kGuwikmsx8UL8pYprzgO7NFTiU0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    SDL2
    libGLU
    libGL
    glew
    ncurses
    c-ares
  ];

  meta = {
    description = "Multiplayer 3D Tank game";
    homepage = "https://bzflag.org/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
