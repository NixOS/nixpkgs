{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella2014";
  version = "0-unstable-2026-07-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "stella2014-libretro";
    rev = "8ddf2146ed2d2053cff9df64192f920e57709629";
    hash = "sha256-VDywbP7PhcQPHhu/KMvV1LlI/iOGjMzRooqvoT+Tnxc=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Stella ~2014 to libretro";
    homepage = "https://github.com/libretro/stella2014-libretro";
    license = lib.licenses.gpl2Only;
  };
}
