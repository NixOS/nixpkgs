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
  version = "0-unstable-2024-10-05";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "d689c50e21bf956913ac607933cd4082eaedc06b";
    hash = "sha256-XIe1JrKVY4ba5WnKrVofWNpJU5pcwUyDd14ZzaGcf+k=";
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
