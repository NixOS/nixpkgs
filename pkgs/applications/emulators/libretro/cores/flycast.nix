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
  version = "0-unstable-2026-02-06";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "c577e29f43edc5a86c6ed4edca46706000d214b2";
    hash = "sha256-nHMtXwtrgxoN/tuY1d+DqZAJFag8vmHAP/9tS2j3ErU=";
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
