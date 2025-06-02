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
  version = "0-unstable-2025-06-01";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "d9ec0cb3ab0ce383f24f86d023e1889b7f37c5c7";
    hash = "sha256-MwXq+qhba+PNS1e2LS3CduWcdO3Tm0OS8ny1Gq3Zo5s=";
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
