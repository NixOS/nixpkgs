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
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    httpbin
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "net-cpp";
  version = "3.1.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/net-cpp";
    rev = finalAttrs.version;
    hash = "sha256-qXKuFLmtPjdqTcBIM07xbRe3DnP7AzieCy7Tbjtl0uc=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    # Enable disabling of Werror
    # Remove when version > 3.1.0
    (fetchpatch {
      name = "0001-net-cpp-Add-ENABLE_WERROR-option.patch";
      url = "https://gitlab.com/ubports/development/core/lib-cpp/net-cpp/-/commit/0945180aa6dd38245688d5ebc11951b272e93dc4.patch";
      hash = "sha256-91YuEgV+Q9INN4BJXYwWgKUNHHtUYz3CG+ROTy24GIE=";
    })

    # Enable opting out of tests
    # https://gitlab.com/ubports/development/core/lib-cpp/net-cpp/-/merge_requests/14
    (fetchpatch {
      name = "0002-net-cpp-Make-tests-optional.patch";
      url = "https://gitlab.com/OPNA2608/net-cpp/-/commit/cfbcd55446a4224a4c913ead3a370cd56d07a71b.patch";
      hash = "sha256-kt48txzmWNXyxvx3DWAJl7I90c+o3KlgveNQjPkhfxA=";
    })

    # Be more lenient with how quickly HTTP test server must be up, for slower hardware / archs
    (fetchpatch {
      url = "https://salsa.debian.org/ubports-team/net-cpp/-/raw/941d9eceaa66a06eabb1eb79554548b47d4a60ab/debian/patches/1007_wait-for-flask.patch";
      hash = "sha256-nsGkZBuqahsg70PLUxn5EluDjmfZ0/wSnOYimfAI4ag=";
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
    "-DENABLE_WERROR=OFF"
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
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "net-cpp"
    ];
  };
})
