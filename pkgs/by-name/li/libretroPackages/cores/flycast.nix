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
  version = "0-unstable-2026-11-22";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "105342d53fc181493cd372c8f1ebf5c49621ed1a";
    hash = "sha256-sMbv3q5dOHjUYWX5kgwC/xcwFh8ANrR8q7D1tokDLdg=";
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
