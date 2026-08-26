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
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "c3763d8fc4208dd6f8f0bc456383543b8406a8a0";
    hash = "sha256-/QfEDbodvtrfxe2qEqselWFyv6Lx77Z3fJOZhgwMAIk=";
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
