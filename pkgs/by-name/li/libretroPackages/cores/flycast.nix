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
  version = "0-unstable-2026-10-27";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "1b63c8a3677cc8eb1292863c4fe8fc8f94674fc8";
    hash = "sha256-B99wtCuHJGtTj0bD24XzvGbUY0baaEUHrmZU2FNHStk=";
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
