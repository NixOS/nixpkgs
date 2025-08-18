{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
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

  src = fetchFromGitHub {
    owner = "BZFlag-Dev";
    repo = "bzflag";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6lW3w1n1ZFs+Iw2wd0aJJpSSnymzkNmVLAgreW4l/6k=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

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
