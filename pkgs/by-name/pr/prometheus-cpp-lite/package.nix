{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchpatch,

  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = finalAttrs.src.repo;
  version = "2023-04-13";

  patches = [
    (fetchpatch {
      url = "https://github.com/biaks/prometheus-cpp-lite/commit/1a9794155be9e76397ebd359baf9a8d1853d90b2.patch";
      hash = "sha256-DIAwpvYKuf3vjk0upnYKqrx+o2pgYzn7yaGNCjdMehs";
    })
  ];

  src = fetchFromGitHub {
    owner = "biaks";
    repo = "prometheus-cpp-lite";
    rev = "48d09c45ee6deb90e02579b03037740e1c01fd27";
    hash = "sha256-XplbP4wHxK9z8Q5fOnaiL7vzXBaZTJyo/tmXUJN/mb4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = ''
      C++ header-only prometheus client library for quickly and easily adding metric (and profiling) functionality to C++ projects.
    '';
    # TODO maintainer, nix@greenkeypartners.io?
  };
})
