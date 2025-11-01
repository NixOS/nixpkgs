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
  version = "0-unstable-2025-10-21";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "bf2bd7efed41e9f3367a764c2d90fcaa9c38a1f9";
    hash = "sha256-iYBZjxt0StvkCLIim6iYrr6wxjAEAOj8109Jn4YUwe4=";
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
