{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  cmake,
  libGL,
  libGLU,
}:
mkLibretroCore {
  core = "flycast";
  version = "0-unstable-2025-12-15";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "f65907a25625403ef0e20548ed5fbbf25ba9e5ca";
    hash = "sha256-QuuHSGTL4Di5LBFqGZ9ISwgUQIbC7uZNMA5Xv7+ijuc=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [ cmake ];
  extraBuildInputs = [
    libGL
    libGLU
  ];
  cmakeFlags = [ "-DLIBRETRO=ON" ];
  makefile = "Makefile";

  meta = {
    description = "Flycast libretro port";
    homepage = "https://github.com/flyinghead/flycast";
    license = lib.licenses.gpl2Only;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
