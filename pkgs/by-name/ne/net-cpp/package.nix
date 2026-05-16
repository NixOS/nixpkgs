{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
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
  version = "3.2.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/net-cpp";
    tag = finalAttrs.version;
    hash = "sha256-1rUPdN62u4eYtrXgoVaeSHro4gnAfFAl1brt+tE45oE=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    # Remove when version > 3.2.1
    (fetchpatch {
      name = "0001-net-cpp-Look-for-python3-executable-at-configure-time-instead-of-hardcoding-a-path.patch";
      url = "https://gitlab.com/ubports/development/core/lib-cpp/net-cpp/-/commit/811da28f36f34cc2ea32dc96b2c65932d4f954b0.patch";
      hash = "sha256-CC7fEuRNuf5TNEfhFJr9VLWFWfTnFtIvSTUoCcwGe68=";
    })
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
