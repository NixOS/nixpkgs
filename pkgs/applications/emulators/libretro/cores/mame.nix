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
  version = "0-unstable-2026-07-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame";
    rev = "e2f8a31819e9e510dd06ab11f0d387ca7789776e";
    hash = "sha256-LzN5rbo8kev8aogIMTQMLXseZBzx2XtDGGEUtABW92M=";
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
