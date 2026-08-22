{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bk";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bk-emulator";
    rev = "fe64da42ee463c1b2f4d0566e4d0f7a9667506f6";
    hash = "sha256-eRAG2KYc7+b25rZw/cJ/o7RTuumqR1Cr1afh/A0TgkY=";
  };

  meta = {
    description = "BK-0010/0011/Terak 8510a emulator";
    homepage = "https://github.com/libretro/bk-emulator";
    license = lib.licenses.free;
  };
}
