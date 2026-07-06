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
  version = "0-unstable-2026-05-22";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "bb304918f8d9f1d2c1e80ccabfa86806ef70bcfa";
    hash = "sha256-ZtPXCv1nte0Z39jvZremR9POSanz+MZbkzqFXtoZLqc=";
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
