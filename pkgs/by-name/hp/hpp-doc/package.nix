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
  pname = "hpp-doc";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-doc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GEseaoFwOE7ztqRf3X+Dztcnk9JSxnzpgoQpxLZXhBQ=";
  };

  prePatch = ''
    substituteInPlace scripts/packageDep --replace-fail \
      "/usr/bin/env python3" \
      ${python3Packages.python.interpreter}
  '';

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
    python3Packages.hpp-practicals
    python3Packages.hpp-tutorial
  ];

  doCheck = true;

  meta = {
    description = "Documentation for project Humanoid Path Planner";
    homepage = "https://github.com/humanoid-path-planner/hpp-doc";
    changelog = "https://github.com/humanoid-path-planner/hpp-doc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
