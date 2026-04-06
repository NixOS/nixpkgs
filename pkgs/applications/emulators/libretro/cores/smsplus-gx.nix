{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "smsplus";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "smsplus-gx";
    rev = "41212ee3309fcf84ef0c04317a0916f0e1252c00";
    hash = "sha256-7IKnFdSYCVrwjvtP4cTxQCCKANYSVVR6IwrhnjzqPPg=";
  };

  meta = {
    description = "SMS Plus GX libretro port";
    homepage = "https://github.com/libretro/smsplus-gx";
    license = lib.licenses.gpl2Plus;
  };
}
