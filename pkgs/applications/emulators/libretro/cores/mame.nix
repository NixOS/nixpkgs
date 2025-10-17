{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  python3,
  alsa-lib,
  libGLU,
  libGL,
}:
mkLibretroCore {
  core = "mame";
  version = "0-unstable-2025-09-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame";
    rev = "61743c76180f1ad454227ed1be0261a071d37d67";
    hash = "sha256-R7zBl8Y5tnG+CkFgyTdwlGlCLwG/9Svs3hsJJp12fOY=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [ python3 ];
  extraBuildInputs = [
    alsa-lib
    libGLU
    libGL
  ];
  # Setting this is breaking compilation of src/3rdparty/genie for some reason
  makeFlags = [ "ARCH=" ];

  meta = {
    description = "Port of MAME to libretro";
    homepage = "https://github.com/libretro/mame";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
  };
}
