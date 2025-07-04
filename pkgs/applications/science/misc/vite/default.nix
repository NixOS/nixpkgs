{
  stdenv,
  fetchFromGitLab,
  lib,
  cmake,
  qtbase,
  qttools,
  qtcharts,
  libGLU,
  libGL,
  glm,
  glew,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "vite";
  version = "unstable-2022-05-17";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "solverstack";
    repo = pname;
    rev = "6d497cc519fac623e595bd174e392939c4de845c";
    hash = "sha256-Yf2jYALZplIXzVtd/sg6gzEYrZ+oU0zLG1ETd/hiTi0=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    qtcharts
    libGLU
    libGL
    glm
    glew
  ];

  meta = {
    description = "Visual Trace Explorer (ViTE), a tool to visualize execution traces";
    mainProgram = "vite";

    longDescription = ''
      ViTE is a trace explorer. It is a tool to visualize execution
      traces in Pajé or OTF format for debugging and profiling
      parallel or distributed applications.
    '';

    homepage = "http://vite.gforge.inria.fr/";
    license = lib.licenses.cecill20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
