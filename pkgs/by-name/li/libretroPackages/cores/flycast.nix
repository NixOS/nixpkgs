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
  version = "0-unstable-2026-09-26";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "ea087b9140ff5a3b1809e090da0f8d644ee2db95";
    hash = "sha256-jZBnVX4x9v5hEpK7gzZTk9Qs2EeVqREQle57kPjuWUE=";
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
