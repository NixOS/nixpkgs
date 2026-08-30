{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-07-29";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "154a467c3a1ba6fa1d85c6776ac4f3b27558e5ad";
    hash = "sha256-oD0JCgb6csW+LC7TsF2ei7OEaDY5fzj5B8MyKCrr+SU=";
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
