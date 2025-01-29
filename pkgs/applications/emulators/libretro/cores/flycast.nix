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
  version = "0-unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "2e8984804170afce31a6d85e10ee4e153bbfb5aa";
    hash = "sha256-jOOfYZ33SZM39vaJ/OqL7OpvIjuYoSewspOWNVTOBdk=";
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
