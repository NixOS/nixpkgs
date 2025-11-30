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
  version = "0-unstable-2025-11-22";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "1666eb0875613ee16b04e08be8ed89c27dbd5c25";
    hash = "sha256-uQvr4C8iO+3FXh6ki+Rgv7Y/+p1WHwXuqy9Xyq4gSeo=";
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
