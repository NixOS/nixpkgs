{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  pkg-config,
  gtest,
  doxygen,
  graphviz,
  lomiri,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "properties-cpp";
  version = "0.0.4";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/properties-cpp";
    rev = finalAttrs.version;
    hash = "sha256-rxv2SPTXubaIBlDZixBZ88wqM7pxY03dVhRVImcDZtA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ];

  buildInputs = [
    lomiri.cmake-extras
  ];

  checkInputs = [
    gtest
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    homepage = "https://gitlab.com/ubports/development/core/lib-cpp/properties-cpp";
    description = "Very simple convenience library for handling properties and signals in C++11";
    license = licenses.lgpl3Only;
    platforms = platforms.linux;
    pkgConfigModules = [
      "properties-cpp"
    ];
  };
})
