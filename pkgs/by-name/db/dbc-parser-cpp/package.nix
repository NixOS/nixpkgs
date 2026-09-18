{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fast-float,
  catch2_3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dbc-parser-cpp";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "LinuxDevon";
    repo = "dbc_parser_cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oyC7NihrlYvoR3CH07FeZcXfQ1JH2Ymsb7ocgim4dZ8=";
  };

  patches = [
    # Submitted upstream:  https://github.com/LinuxDevon/dbc_parser_cpp/pull/37
    # Remove when upstream merges the PR
    ./0001-fix-pkg-config-file.patch
  ]
  # Submitted upstream: https://github.com/LinuxDevon/dbc_parser_cpp/pull/36
  # Remove when upstream merges the PR
  ++ lib.optional stdenv.hostPlatform.isAarch64 ./0002-fix-testcase-aarch64.patch;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fast-float
  ];

  checkInputs = [
    catch2_3
  ];

  cmakeFlags = [
    (lib.cmakeBool "DBC_ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    # Cmake test file doesn't check for system installed Catch2 and directly uses FetchContent to download Catch2
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
  ];

  doCheck = true;

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "DBC file parsing library written in C++";
    homepage = "https://github.com/LinuxDevon/dbc_parser_cpp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      AhmedAmr
    ];
    teams = with lib.teams; [ ngi ];
    platforms = lib.platforms.all;
  };
})
