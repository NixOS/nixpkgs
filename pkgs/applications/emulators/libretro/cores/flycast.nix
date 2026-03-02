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
  version = "0-unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "ba5b3c71ecc966e52f698f41443e7cc9b81bf824";
    hash = "sha256-tbq+NgbZDKMg0K0cWF1+7h80QTaAaO5BD9nf94z5fc0=";
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
