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
  version = "0-unstable-2025-09-28";

  src = fetchFromGitHub {
    owner = "managarm";
    repo = "frigg";
    rev = "85c57024c53fb7fdb4a5dfdc5beca75248f0d7d7";
    sha256 = "sha256-fmoa+hOqZvBRhtUxknK0uXan1JHJgdpYx+ICQgooYpA=";
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
