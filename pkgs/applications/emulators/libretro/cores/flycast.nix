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
  version = "0-unstable-2026-03-20";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "05b270f05cecfcd675bb0530cf18d0a9b81269a1";
    hash = "sha256-sXoxuDiMnArXxYtIKmU6LBQ1r8KpEr/0hHliLN3KQWw=";
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
