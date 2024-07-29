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
  pname = "hpp-practicals";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-practicals";
    tag = "v${finalAttrs.version}";
    hash = "sha256-boa0B5eGyLHum5ncIBB2nCI3Ru92avdbBGwd+AeIQ3o=";
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
    python3Packages.hpp-gepetto-viewer
    python3Packages.hpp-gui
    python3Packages.hpp-plot
  ];

  doCheck = true;

  meta = {
    description = "Practicals for Humanoid Path Planner software";
    homepage = "https://github.com/humanoid-path-planner/hpp-practicals";
    changelog = "https://github.com/humanoid-path-planner/hpp-practicals/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
