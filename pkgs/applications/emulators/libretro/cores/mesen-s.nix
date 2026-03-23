{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mesen-s";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mesen-s";
    rev = "d4fca31a6004041d99b02199688f84c009c55967";
    hash = "sha256-mGGTLBRJCsNJg57LWSFndIv/LLzEmVRnv6gNbllkV/Y=";
  };

  makefile = "Makefile";
  preBuild = "cd Libretro";
  normalizeCore = false;

  meta = {
    description = "Port of Mesen-S to libretro";
    homepage = "https://github.com/libretro/mesen-s";
    license = lib.licenses.gpl3Only;
  };
}
