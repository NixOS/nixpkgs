{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2024-11-17";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "0e2ce2771c7d0c9b2dd5c06e3a4746738d3c9e47";
    hash = "sha256-axt5wvH7WENh1ALPYc+f5XpCv2xPm5jYx26zMhLEt3E=";
  };

  makefile = "Makefile";
  preBuild = "cd src/os/libretro";
  dontConfigure = true;

  meta = {
    description = "Port of Stella to libretro";
    homepage = "https://github.com/stella-emu/stella";
    license = lib.licenses.gpl2Only;
  };
}
