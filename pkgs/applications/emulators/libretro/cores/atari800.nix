{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "atari800";
  version = "0-unstable-2026-07-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-atari800";
    rev = "9d3bcf283502512052e21c6f1453fbdf7aa3122b";
    hash = "sha256-uLMQWi+Z21irwkFBArlHNXILintSWF7PfGy5bgKmAhQ=";
  };

  makefile = "Makefile";
  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Port of Atari800 to libretro";
    homepage = "https://github.com/libretro/libretro-atari800";
    license = lib.licenses.gpl2Only;
  };
}
