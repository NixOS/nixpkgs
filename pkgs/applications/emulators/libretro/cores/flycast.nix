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
  version = "0-unstable-2026-05-01";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "744e9e4aa560d785000a2653ee3d291716aa2c0a";
    hash = "sha256-gCFX8mWWWsSogaBDtbVx4hL/GiNk5YlsT2HP3LNY0zs=";
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
