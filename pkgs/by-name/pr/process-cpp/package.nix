{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch2,
  testers,
  gitUpdater,
  cmake,
  coreutils,
  boost,
  gtest,
  lomiri,
  properties-cpp,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "process-cpp";
  version = "3.0.2";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "ubports";
    repo = "development/core/lib-cpp/process-cpp";
    rev = finalAttrs.version;
    hash = "sha256-UCNmD5Ea2wnEwG9gkt88TaX0vfS4SCaIOPRMeNFx80Y=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Fix compat with CMake 4
    # Remove when version > 3.0.2
    (fetchpatch2 {
      name = "0001-process-cpp-Bump-cmake_minimum_required-to-version-3.10.patch";
      url = "https://gitlab.com/ubports/development/core/lib-cpp/process-cpp/-/commit/c374b62cb79d668505c1c8dc55edddc938a573ba.diff";
      hash = "sha256-2H6f+EAR7p4mb0ReNl8LaosPVF/CNRm+PiYV7tkOQ/w=";
    })
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

  checkInputs = [ gtest ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck) ];

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
