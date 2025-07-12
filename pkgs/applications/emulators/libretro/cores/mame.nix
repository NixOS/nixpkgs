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
  version = "0-unstable-2025-07-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame";
    rev = "fba50741006fa3e27e1897f589d2048a505b8fd6";
    hash = "sha256-hRaLnxmG3B8IxpiKdiZEEMfKxDOPZg5ew7gwdq08TPQ=";
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
