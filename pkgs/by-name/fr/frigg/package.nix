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
  version = "0-unstable-2025-07-05";

  src = fetchFromGitHub {
    owner = "managarm";
    repo = "frigg";
    rev = "d4d587ccc92cf00abf8b0af5c7469b099a26a0a8";
    sha256 = "sha256-7Yplmw/AqOFvOlzfOB83r1eLprjdSpHQdeScErrY0Wo=";
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
