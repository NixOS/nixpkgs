{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "7.0-unstable-2024-12-09";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "91417312f1a756a1dac88d1df1cecc7362ff7a44";
    hash = "sha256-e8b9kCsa5FxyMExqppCX1jE0YmK1T1n8fORBBSvyE54=";
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
