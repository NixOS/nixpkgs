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
  version = "0-unstable-2026-09-15";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "8933f9fe0ccd3f7cbe2e77717ea3a6db8b472129";
    hash = "sha256-6XBCWmyVRSbfAbaxvFpe6/39kPYrqvefsjebXZu7yuY=";
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
