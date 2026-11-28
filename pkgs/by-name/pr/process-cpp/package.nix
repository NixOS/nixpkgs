{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  makeFontsConf,
  testers,
  boost,
  cmake,
  coreutils,
  doxygen,
  graphviz,
  gtest,
  lomiri,
  properties-cpp,
  pkg-config,
  writableTmpDirAsHomeHook,
  withDocumentation ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "process-cpp";
  version = "3.1.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/process-cpp";
    rev = finalAttrs.version;
    hash = "sha256-WVC3kc4ueXjt7ppiobGg9hi4DxgPDGoJ1x4JlHhrysA=";
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
      --replace-fail '/usr/bin/sleep' '${lib.getExe' coreutils "sleep"}'
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals withDocumentation [
    doxygen
    graphviz
    writableTmpDirAsHomeHook # silencing fontconfig warnings
  ];

  buildInputs = [
    boost
    lomiri.cmake-extras
    properties-cpp
  ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    (lib.cmakeBool "PROCESS_CPP_ENABLE_DOC_GENERATION" withDocumentation)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  env = lib.optionalAttrs withDocumentation {
    # silence fontconfig warnings
    FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };
  };

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
      version = "${lib.versions.major finalAttrs.version}.0.0";
    };
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
