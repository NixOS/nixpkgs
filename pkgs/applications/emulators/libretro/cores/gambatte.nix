{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "4c1b4c26c8db94663196bad187b58fe8e9162b4f";
    hash = "sha256-uJoHwHJ2KtNk83eEDdWPPxAViMCp8bVq06wsBxQZEPw=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
