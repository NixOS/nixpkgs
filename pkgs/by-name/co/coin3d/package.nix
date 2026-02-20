{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  libGL,
  libGLU,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coin";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "coin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XBkb8CbfAXBwOO9JkExpsy8HxtbZo3/fnU6cReuSETI=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libGL
    libGLU
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libx11;

  meta = {
    homepage = "https://github.com/coin3d/coin";
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    mainProgram = "coin-config";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
