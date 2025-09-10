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
  version = "0-unstable-2025-08-29";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "0243f81c264ea8d1bbaa107f26fb6644f767c1e8";
    hash = "sha256-iLEOAOMzdhlG4qogJiAhdK03YZ57dAV15TwBBjK7iSY=";
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
