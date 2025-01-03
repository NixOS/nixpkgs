{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  libGLU,
  libGL,
}:
mkLibretroCore {
  core = "melonds";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "melonds";
    rev = "7a3c11ff970cd36ca806961fae6db94b30dd5401";
    hash = "sha256-YGkRdth7qdATcZpJkBd5MGOJFG1AbeJhAnyir+ssZYA=";
  };

  extraBuildInputs = [
    libGLU
    libGL
  ];
  makefile = "Makefile";

  meta = {
    description = "Port of MelonDS to libretro";
    homepage = "https://github.com/libretro/melonds";
    license = lib.licenses.gpl3Only;
  };
}
