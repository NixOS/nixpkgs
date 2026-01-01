{
  lib,
  boost,
  bzip2,
  cmake,
  curl,
  fetchFromGitHub,
  icu,
  libGL,
  libGLU,
  mkLibretroCore,
  openssl,
  xorg,
}:
mkLibretroCore {
  core = "play";
<<<<<<< HEAD
  version = "0-unstable-2025-12-23";
=======
  version = "0-unstable-2025-11-03";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jpd002";
    repo = "Play-";
<<<<<<< HEAD
    rev = "d0f1375248e3003199cb973a12332b4cc9f0724f";
    hash = "sha256-uMPlJDjLmXDO9mrnjYu/3Fr5qwBBADUARTMz1hckLJM=";
=======
    rev = "77c62d3a942e219bc9d072b4800fa0881208ce2a";
    hash = "sha256-ROrANubftSJwGl9THdAIRhSFOy1uHZ6v2kAmYWLDhN0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  extraBuildInputs = [
    boost
    bzip2
    curl
    openssl
    icu
    libGL
    libGLU
    xorg.libX11
  ];
  extraNativeBuildInputs = [ cmake ];
  makefile = "Makefile";
  cmakeFlags = [
    "-DBUILD_PLAY=OFF"
    "-DBUILD_LIBRETRO_CORE=ON"
  ];
  postBuild = "cd Source/ui_libretro";
  # FIXME: workaround the following GCC 13 error:
  # error: 'printf' was not declared in this scop
  env.CXXFLAGS = "-include cstdio";

  meta = {
    description = "Port of Play! to libretro";
    homepage = "https://github.com/jpd002/Play-";
    license = lib.licenses.bsd2;
  };
}
