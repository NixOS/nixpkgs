{
  lib,
  fetchFromGitHub,
  fetchpatch,
  stdenvNoLibc,
  buildPackages,
  gbenchmark,
  gtest,
  meson,
  mimalloc,
  ninja,
  pkg-config,
}:
stdenvNoLibc.mkDerivation {
  pname = "frigg";
  version = "0-unstable-2026-06-08";

  src = fetchFromGitHub {
    owner = "managarm";
    repo = "frigg";
    rev = "65db297ebd6db09e86fe737175631a872d81c39b";
    sha256 = "sha256-Jp/tzwYVmfbVh81K1GvHXOQJJnN+yNfr54iEPEEJ+s4=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/managarm/frigg/pull/135.patch";
      sha256 = "sha256-h06jN3KjMlreW1BLgE/QHcbN0ka6bx2R0btxlxK7XcI=";
    })
  ];

  # We need these to be in depsBuildBuild so that tests can be built against
  # the host toolchain. frigg is a header-only library, and a dependency of
  # mlibc, so it needs to be built with stdenvNoLibc.
  depsBuildBuild = [
    buildPackages.stdenv.cc
    pkg-config
    meson
  ];

  nativeBuildInputs = [
    ninja
    pkg-config
  ];

  doCheck = true;

  nativeCheckInputs = [
    gbenchmark
    gtest
    mimalloc
  ];

  mesonFlags = lib.optionals (!stdenvNoLibc.buildPlatform.canExecute stdenvNoLibc.hostPlatform) [
    "-Dbuild_tests=disabled"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Lightweight C++ utilities and algorithms for system programming";
    homepage = "https://github.com/managarm/frigg";
    platforms = lib.platforms.all;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lzcunt ];
  };
}
