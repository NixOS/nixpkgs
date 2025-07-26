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
  pname = "hpp-gepetto-viewer";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-gepetto-viewer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tWPyeEc8mpC5nE+z4Wb7BRTEXfQxhzshl8nBx8AXHAo=";
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
    python3Packages.hpp-corbaserver
  ];

  doCheck = true;

  meta = {
    description = "Display of hpp robots and obstacles in gepetto-viewer";
    homepage = "https://github.com/humanoid-path-planner/hpp-gepetto-viewer";
    changelog = "https://github.com/humanoid-path-planner/hpp-gepetto-viewer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
