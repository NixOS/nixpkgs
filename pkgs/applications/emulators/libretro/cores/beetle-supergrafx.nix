{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-supergrafx";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-supergrafx-libretro";
    rev = "3c6fcd3deded54ebecd69408f108407ac03d11b5";
    hash = "sha256-VO8Bn67n3D9fxbbTxwbf9iKLDueIi98zIso1qMQcrMI=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's SuperGrafx core to libretro";
    homepage = "https://github.com/libretro/beetle-supergrafx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
