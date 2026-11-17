{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  makeFontsConf,
  testers,
  boost,
  cmake,
  curl,
  doxygen,
  graphviz,
  gtest,
  jsoncpp,
  lomiri,
  pkg-config,
  process-cpp,
  properties-cpp,
  python3,
  validatePkgConfig,
  writableTmpDirAsHomeHook,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      httpbin
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "net-cpp";
  version = "3.2.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/net-cpp";
    tag = finalAttrs.version;
    hash = "sha256-etlyfM7gGNL3mG7kn5xpd821M6QKoCiqJtTMcXRGtjs=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    validatePkgConfig
    writableTmpDirAsHomeHook # makes doc generation quieter
  ];

  buildInputs = [
    boost
    curl
  ];

  nativeCheckInputs = [
    pkg-config
    pythonEnv
  ];

  checkInputs = [
    lomiri.cmake-extras
    gtest
    jsoncpp
    process-cpp
    properties-cpp
  ];

  cmakeFlags = [
    # For catching upcoming issues & reporting them to upstream
    (lib.cmakeBool "ENABLE_WERROR" true)
  ];

  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Tests start HTTP server in separate process with fixed URL, parallelism breaks things
  enableParallelChecking = false;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Simple yet beautiful networking API for C++11";
    homepage = "https://gitlab.com/ubports/development/core/lib-cpp/net-cpp";
    changelog = "https://gitlab.com/ubports/development/core/lib-cpp/net-cpp/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "net-cpp"
    ];
  };
})
