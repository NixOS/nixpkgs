{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pce";
  version = "0-unstable-2024-11-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pce-libretro";
    rev = "af28fb0385d00e0292c4703b3aa7e72762b564d2";
    hash = "sha256-W+74RTIidSUdviihLy926OvlSdqMECvOLEEiWMtB50w=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PC Engine core to libretro";
    homepage = "https://github.com/libretro/beetle-pce-libretro";
    license = lib.licenses.gpl2Only;
  };
}
