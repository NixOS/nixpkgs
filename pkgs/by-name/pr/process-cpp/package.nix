{
  lib,
  stdenv,
  fetchFromGitLab,
  testers,
  gitUpdater,
  boost,
  cmake,
  coreutils,
  doxygen,
  graphviz,
  gtest,
  lomiri,
  properties-cpp,
  pkg-config,
  withDocumentation ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "process-cpp";
  version = "3.0.3";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "ubports";
    repo = "development/core/lib-cpp/process-cpp";
    rev = finalAttrs.version;
    hash = "sha256-PmlgzCEvBPC0k/pU6xneKINOGAas+hDWIrWUEkj+rDU=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocumentation [
    "doc"
  ];

  postPatch = ''
    substituteInPlace data/process-cpp.pc.in \
      --replace-fail 'libdir=''${exec_prefix}' 'libdir=''${prefix}' \
      --replace-fail 'includedir=''${exec_prefix}' 'includedir=''${prefix}'

    substituteInPlace tests/posix_process_test.cpp \
      --replace-fail '/usr/bin/sleep' '${lib.getExe' coreutils "sleep"}' \
      --replace-fail '/usr/bin/env' '${lib.getExe' coreutils "env"}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals withDocumentation [
    doxygen
    graphviz
  ];

  buildInputs = [
    boost
    lomiri.cmake-extras
    properties-cpp
  ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "PROCESS_CPP_ENABLE_DOC_GENERATION" withDocumentation)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Simple convenience library for handling processes in C++11";
    homepage = "https://gitlab.com/ubports/development/core/lib-cpp/process-cpp";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
    ];
    maintainers = with lib.maintainers; [
      onny
      OPNA2608
    ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "process-cpp" ];
  };
})
