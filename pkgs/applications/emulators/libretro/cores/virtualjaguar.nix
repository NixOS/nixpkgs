{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "virtualjaguar";
  version = "0-unstable-2026-04-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "virtualjaguar-libretro";
    rev = "dd44259f8dca0ba87068eb2264367c01e131c263";
    hash = "sha256-prvUvHXOeSWG5BK4mHkkFVnq0xGc3pI09GDNJJvZfgs=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of VirtualJaguar to libretro";
    homepage = "https://github.com/libretro/virtualjaguar-libretro";
    license = lib.licenses.gpl3Only;
  };
}
