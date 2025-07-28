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
  version = "0-unstable-2025-07-25";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "5743502cdddb7a64cb220bab9cb90f3a88c85aff";
    hash = "sha256-VCKDgk8JN74ZB1f/C4kILZXsxaSc7IQQ7kc0LNV4wTs=";
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
