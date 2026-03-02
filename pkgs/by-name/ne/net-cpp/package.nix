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
  version = "3.2.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/net-cpp";
    rev = finalAttrs.version;
    hash = "sha256-JfVSAwBWtHw7a0CtY5C1xuxThO3FbS4MgNuIO1CGuts=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    # Remove when version > 3.2.0
    (fetchpatch {
      name = "0001-net-cpp-fix-compatibility-with-Boost-1.88.patch";
      url = "https://gitlab.com/ubports/development/core/lib-cpp/net-cpp/-/commit/9ff8651b11eb9dc0f64147001e10a57d1546a626.patch";
      hash = "sha256-IEa3nhnv0oa5WmhIDG3OMrZmmoAZFeedAzKXAKVTIQg=";
    })
  ];

  postPatch =
    # https://gitlab.com/ubports/development/core/lib-cpp/net-cpp/-/merge_requests/22, too basic to bother with fetchpatch
    ''
      substituteInPlace src/CMakeLists.txt \
        --replace-fail 'find_package(Boost COMPONENTS system' 'find_package(Boost COMPONENTS'
    ''
    + lib.optionalString finalAttrs.finalPackage.doCheck ''
      # Use wrapped python. Removing just the /usr/bin doesn't seem to work?
      substituteInPlace tests/httpbin.h.in \
        --replace '/usr/bin/python3' '${lib.getExe pythonEnv}'
    '';

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
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
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
