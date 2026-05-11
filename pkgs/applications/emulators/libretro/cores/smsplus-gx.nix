{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "smsplus";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "smsplus-gx";
    rev = "6dc7119f6f8d7f6437320405ee3b0de5f227913f";
    hash = "sha256-kWq4yzYl0ZTnnhLfhtgPyf2CRequ6yn2DLp3Yc7EBbA=";
  };

  meta = {
    description = "SMS Plus GX libretro port";
    homepage = "https://github.com/libretro/smsplus-gx";
    license = lib.licenses.gpl2Plus;
  };
}
