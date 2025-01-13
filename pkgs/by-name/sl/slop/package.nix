{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  glew,
  glm,
  libGLU,
  libGL,
  libX11,
  libXext,
  libXrender,
  icu,
  libSM,
}:

stdenv.mkDerivation rec {
  pname = "slop";
  version = "7.6";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "slop";
    rev = "v${version}";
    sha256 = "sha256-LdBQxw8K8WWSfm4E2QpK4GYTuYvI+FX5gLOouVFSU/U=";
  };

  patches = [
    (fetchpatch {
      # From Upstream PR#135: https://github.com/naelstrof/slop/pull/135
      name = "Fix-linking-of-GLEW-library.patch";
      url = "https://github.com/naelstrof/slop/commit/811b7e44648b9dd6c1da1554e70298cf4157e5fe.patch";
      sha256 = "sha256-LNUrAeVZUJFNOt1csOaIid7gLBdtqRxp8AcC7f3cnIQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glew
    glm
    libGLU
    libGL
    libX11
    libXext
    libXrender
    icu
    libSM
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Queries a selection from the user and prints to stdout";
    platforms = lib.platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "slop";
  };
}
