{
  lib,
  fetchFromGitHub,
  stdenv,

  cmake,
  doxygen,
  libsForQt5,
  pkg-config,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-plot";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-plot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0nrIfap+nATODcHH9/iJseqB+veMGO8eS+50df+lm6k=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    libsForQt5.wrapQtAppsHook
    pkg-config
    python3Packages.python
  ];
  buildInputs = [ libsForQt5.qtbase ];
  propagatedBuildInputs = [
    python3Packages.gepetto-viewer-corba
    python3Packages.hpp-manipulation-corba
  ];

  doCheck = true;

  meta = {
    description = "Graphical utilities for constraint graphs in hpp-manipulation";
    homepage = "https://github.com/humanoid-path-planner/hpp-plot";
    changelog = "https://github.com/humanoid-path-planner/hpp-plot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
