{ lib
, stdenv
, fetchFromGitLab
, testers
, unstableGitUpdater
, cmake
, coreutils
, boost
, gtest
, lomiri
, properties-cpp
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "process-cpp";
  version = "3.0.1-unstable-2024-03-14";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "ubports";
    repo = "development/core/lib-cpp/process-cpp";
    rev = "7b0a829abcbcdd25d949e5f9e2c26bb985a58b31";
    hash = "sha256-Az+lSJ7uVR4pAWvOeah5vFtIPb12eKp0nAFF1qsHZXA=";
  };

  outputs = [
    "out"
    "dev"
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
  ];

  buildInputs = [
    boost
    lomiri.cmake-extras
    properties-cpp
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "Simple convenience library for handling processes in C++11";
    homepage = "https://gitlab.com/ubports/development/core/lib-cpp/process-cpp";
    license = with licenses; [ gpl3Only lgpl3Only ];
    maintainers = with maintainers; [ onny OPNA2608 ];
    platforms = platforms.linux;
    pkgConfigModules = [ "process-cpp" ];
  };
})
