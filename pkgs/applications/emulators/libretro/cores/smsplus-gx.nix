{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "smsplus";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "smsplus-gx";
    rev = "c642bbd0680b5959180a420036108893d0aec961";
    hash = "sha256-SHBrwzLyVZ4Tp/kVCnr4xj2B3pmdg+JUmZUM7hYao64=";
  };

  meta = {
    description = "SMS Plus GX libretro port";
    homepage = "https://github.com/libretro/smsplus-gx";
    license = lib.licenses.gpl2Plus;
  };
}
