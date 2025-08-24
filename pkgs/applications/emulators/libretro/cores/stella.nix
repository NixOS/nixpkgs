{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "ad52b906d91e20adc5e2c287ae567de2317adcb5";
    hash = "sha256-9qgK3N3h+1iZSsqVwfDvZPHc4VJ3GY7ekAqnLozNayw=";
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
