{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "freechaf";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "FreeChaF";
    rev = "76c7a84f1f7e80f3e6f2bba96fe100cb24e99124";
    hash = "sha256-gLmDO2yzZbdcD82IUT6NWR0umUExtBqnAK+ltBxGPiM=";
    fetchSubmodules = true;
  };

  makefile = "Makefile";

  meta = {
    description = "Fairchild Channel F emulator core for libretro";
    homepage = "https://github.com/libretro/FreeChaF";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
