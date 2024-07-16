{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, boost
, cmake
, curl
, doxygen
, graphviz
, gtest
, jsoncpp
, lomiri
, pkg-config
, process-cpp
, properties-cpp
, python3
, validatePkgConfig
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    httpbin
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "net-cpp";
  version = "3.1.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/net-cpp";
    rev = finalAttrs.version;
    hash = "sha256-MSqdP3kGI9hDdxFv2a0yd5ZkFkf1lMurB+KDIZLR9jg=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    # Be more lenient with how quickly HTTP test server must be up, for slower hardware / archs
    (fetchpatch {
      url = "https://salsa.debian.org/ubports-team/net-cpp/-/raw/941d9eceaa66a06eabb1eb79554548b47d4a60ab/debian/patches/1007_wait-for-flask.patch";
      hash = "sha256-nsGkZBuqahsg70PLUxn5EluDjmfZ0/wSnOYimfAI4ag=";
    })
    # Bump std version to 14 for gtest 1.13+
    (fetchpatch {
      url = "https://salsa.debian.org/ubports-team/net-cpp/-/raw/f3a031eb7e4ce7df00781100f16de58a4709afcb/debian/patches/0001-Bump-std-version-to-14-needed-for-googletest-1.13.0.patch";
      hash = "sha256-3ykqCfZjtTx7zWQ5rkMhVp7D5fkpoCjl0CVFwwEd4U4=";
    })
  ];

  postPatch = lib.optionalString finalAttrs.finalPackage.doCheck ''
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
    # https://gitlab.com/ubports/development/core/lib-cpp/net-cpp/-/issues/4
    (lib.cmakeBool "ENABLE_WERROR" false)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Tests start HTTP server in separate process with fixed URL, parallelism breaks things
  enableParallelChecking = false;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Simple yet beautiful networking API for C++11";
    homepage = "https://gitlab.com/ubports/development/core/lib-cpp/net-cpp";
    changelog = "https://gitlab.com/ubports/development/core/lib-cpp/net-cpp/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "net-cpp"
    ];
  };
})
