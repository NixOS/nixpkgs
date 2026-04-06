{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "virtualjaguar";
  version = "0-unstable-2026-04-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "virtualjaguar-libretro";
    rev = "68265f930f6120f8f05c1f71c9fc9e417dab0d28";
    hash = "sha256-BWpOm0DECqTqbQ1FR9YgjxjsxU7LdB4MlYHzGatcrJk=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of VirtualJaguar to libretro";
    homepage = "https://github.com/libretro/virtualjaguar-libretro";
    license = lib.licenses.gpl3Only;
  };
}
