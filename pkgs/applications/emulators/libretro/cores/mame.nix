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
  version = "0-unstable-2024-12-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame";
    rev = "603e0a4f07d3f35deac8654208acb02e38d2627e";
    hash = "sha256-DuXSx6itjLgxpEoYMAvu15IO3AhpIhxH0GFtftI+oWk=";
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
