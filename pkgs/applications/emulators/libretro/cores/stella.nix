{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-03-29";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "b753f6eefa4bf02af20eacae98caab7d5aabc4a8";
    hash = "sha256-uPRNa7Ofaonyp1ErFel12DyKox9ETYGoT1s3aG96VkU=";
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
