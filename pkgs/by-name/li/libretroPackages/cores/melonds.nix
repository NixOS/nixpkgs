{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  libGLU,
  libGL,
}:
mkLibretroCore {
  core = "melonds";
  version = "0-unstable-2026-07-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "melonds";
    rev = "66b5d2634cd0a79030562811e6e05f5532f800ba";
    hash = "sha256-nQvnXoB8UeaSr6QfYwn18Y18KyLyWvcv/Q3L3SHvaNU=";
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
