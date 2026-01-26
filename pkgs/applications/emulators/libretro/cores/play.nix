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
  version = "0-unstable-2026-01-19";

  src = fetchFromGitHub {
    owner = "jpd002";
    repo = "Play-";
    rev = "bf245b03076b97eed14abd54c79537a59ecc2bd9";
    hash = "sha256-2Tm/CQt+LwAIEWsBRtgm/rZngSHqEohx45UlkaTCHbA=";
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
