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
  version = "0-unstable-2025-07-16";

  src = fetchFromGitHub {
    owner = "jpd002";
    repo = "Play-";
    rev = "45ef864b381ac3c33c671363cd63c4afa53bd97e";
    hash = "sha256-Y96wlbLA++oL8vZlbrd9eXfED+VUWzD/YeYi21dEULk=";
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
