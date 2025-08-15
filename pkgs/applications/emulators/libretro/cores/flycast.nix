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
  version = "0-unstable-2025-08-12";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "33833cfd1ed2d94d907223442fdb8cdafd8d5d80";
    hash = "sha256-6YXWJi3xbImfBMWILzsnwJGvj2XDoHcrWgLDPwaHfJs=";
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
