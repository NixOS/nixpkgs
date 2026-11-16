{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
  hailort_4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dotwriter";
  version = "0-unstable-2022-01-10";
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "hailo-ai";
    repo = "DotWriter";
    rev = "e5fa8f281adca10dd342b1d32e981499b8681daf";
    hash = "sha256-1cJ23AqM+9aYxGVM07nkkY77xClii4znVMCFbf+Sdio=";
  };

  patches = [
    # use standard library pathss
    ./fix-install-paths.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  passthru.updateScript = unstableGitUpdater { };

  __structuredAttrs = true;

  meta = {
    description = "DotWriter is a C++ API for creating DOT files for use with tools such as GraphViz";
    homepage = "https://github.com/hailo-ai/DotWriter";
    license = lib.licenses.mit;
    mainProgram = "dotwriter";
    platforms = lib.platforms.all;
    inherit (hailort_4.meta) maintainers;
  };
})
