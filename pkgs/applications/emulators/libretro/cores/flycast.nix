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
  version = "0-unstable-2025-04-15";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "25a882341d5ebbf8124ddd2a7421592678dfac2e";
    hash = "sha256-N/7JZbEzYaOAoUShkmQd1G61ke1U3OSeFMXS0lqftYU=";
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
