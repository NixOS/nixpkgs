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
  version = "0-unstable-2026-04-12";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "321bdaf08b4b007a720f196ea072c1813b1b7efe";
    hash = "sha256-9Ry5+krdhz2RCmZZh2l6DdcKTgMpcgHwOBG4c7fc/og=";
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
