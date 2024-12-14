{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella2014";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "stella2014-libretro";
    rev = "3cc89f0d316d6c924a5e3f4011d17421df58e615";
    hash = "sha256-2gnFWau7F45SdzoqDUlqYXfXVE1EUPozHZv7BhyRRIA=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Stella ~2014 to libretro";
    homepage = "https://github.com/libretro/stella2014-libretro";
    license = lib.licenses.gpl2Only;
  };
}
