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
  libx11,
}:
mkLibretroCore {
  core = "play";
  version = "0-unstable-2026-04-07";

  src = fetchFromGitHub {
    owner = "jpd002";
    repo = "Play-";
    rev = "d862ad9cae6c76cbe494db54fa985f21bfcef2a8";
    hash = "sha256-//P/ApU/36TamIMepjoBWsUHs2tR5K47V9Gf5HG3goE=";
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
    libx11
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
