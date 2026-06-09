{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-06-01";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "502f15b41708a3911048f2770a320a3ef20b0415";
    hash = "sha256-1/Zl6YNZhsIDJobbzGKAWKGEsep7k/iXAbwL7sK98M8=";
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
