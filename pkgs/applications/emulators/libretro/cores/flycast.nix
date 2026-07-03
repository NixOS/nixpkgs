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
  version = "0-unstable-2026-06-26";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "7ec978e8521f75427ad38eb8f8f4f3cabaa891d0";
    hash = "sha256-3ChQnJP6xI/Wd3BOlkauTYCNQz1MjSHk0lDmjX+Iugg=";
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
