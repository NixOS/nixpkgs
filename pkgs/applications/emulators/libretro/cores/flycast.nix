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
  version = "0-unstable-2025-07-11";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "48c58dbd18501fae92e641b6ee6ca5ca9de0d5c3";
    hash = "sha256-AlvNh+tDY7FEqUm5zgm7072Z1zIXn54tvLGzLbTjLXo=";
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
