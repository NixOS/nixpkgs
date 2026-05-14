{
  stdenv,
  fetchFromGitLab,
  fetchpatch,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "vite";
  version = "1.4";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "solverstack";
    repo = "vite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z2M4BazLzO/NCcq/VKb+tgrZ6QUs+AX0BbzJW809Krg=";
  };

  patches = [
    (fetchpatch {
      name = "cmake4-fix";
      url = "https://gitlab.inria.fr/solverstack/vite/-/commit/0359f78c8b11ced3a79ac4d73f4ecb9087eba1e8.patch";
      hash = "sha256-UMg21ZlwyRSVQ4CD1oKNUkT+RNxqOIQi2WNBLbYPkJg=";
    })
  ];

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
})
