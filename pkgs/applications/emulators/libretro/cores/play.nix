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
  version = "0-unstable-2026-01-26";

  src = fetchFromGitHub {
    owner = "jpd002";
    repo = "Play-";
    rev = "900e599dd26e4b292ff55738cc8881530eed46ce";
    hash = "sha256-9lr7RDSdQ/FN3mgoh8ZTsL1J8vXyab+TqhvM8yp7G7c=";
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
