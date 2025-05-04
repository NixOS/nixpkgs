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
  version = "0-unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "b04f0eb530c09f4b2a7402bd7f3b82e5daa4d173";
    hash = "sha256-JCQEMfQDvnhUcSNiaVwDXAQmkFhgtwtW5XjAD/CBYjo=";
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
