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
  version = "0-unstable-2026-04-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame";
    rev = "18d4628347a2475ba2f34e6bdc4eca81ba38b5f6";
    hash = "sha256-0shdiEw9OFGbgnl2aIwOy5gMb9xjTfTQKFEFEAEbP9Y=";
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
