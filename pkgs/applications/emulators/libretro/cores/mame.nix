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
  version = "0-unstable-2026-08-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame";
    rev = "eb342748c828421bd15a1791162c885bfde61907";
    hash = "sha256-R63AEUlUYh/xDsKCYQZermMYZvJtkDhyDqwr0yZ1Kfo=";
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
