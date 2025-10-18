{
  lib,
  fetchFromGitHub,
  stdenvNoLibc,
  buildPackages,
  gtest,
  meson,
  ninja,
  pkg-config,
}:
stdenvNoLibc.mkDerivation {
  pname = "frigg";
  version = "0-unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "managarm";
    repo = "frigg";
    rev = "98220ab8f3ac6b1f146c360598a334f7f1fc06e1";
    sha256 = "sha256-sT1liz4KVFiSpU8qW7d+i+vVwksJ5G3Td7HfbU7Q6c8=";
  };

  # We need these to be in depsBuildBuild so that tests can be built against
  # the host toolchain. frigg is a header-only library, and a dependency of
  # mlibc, so it needs to be built with stdenvNoLibc.
  depsBuildBuild = [
    buildPackages.stdenv.cc
    meson
  ];

  nativeBuildInputs = [
    ninja
    pkg-config
  ];

  doCheck = true;

  nativeCheckInputs = [
    gtest
  ];

  meta = {
    description = "Lightweight C++ utilities and algorithms for system programming";
    homepage = "https://github.com/managarm/frigg";
    platforms = lib.platforms.all;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ lzcunt ];
  };
}
