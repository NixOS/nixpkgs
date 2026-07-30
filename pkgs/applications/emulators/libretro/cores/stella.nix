{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-07-16";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "61f4282f57934df94e08a2db79ec492aaab5b805";
    hash = "sha256-2pEQzl3aUq5ya9297Aj4MYN2ePkg/dyCvJavRWkyE1U=";
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
