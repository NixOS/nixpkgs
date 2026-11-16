{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "theodore";
  version = "0-unstable-2026-04-03";

  src = fetchFromGitHub {
    owner = "Zlika";
    repo = "theodore";
    rev = "121ae2513d3ee29f0aaf765a64dc086d57e7a4c7";
    hash = "sha256-dEBjoxtX59J4pHMbLLlcJTh/R0458B9XkfvYHSGX89Q=";
  };

  makefile = "Makefile";

  meta = {
    description = "Thomson MO/TO emulator core for libretro";
    homepage = "https://github.com/Zlika/theodore";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
