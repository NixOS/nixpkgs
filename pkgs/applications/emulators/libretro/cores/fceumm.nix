{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "dbf1f2eb83ebde54a32fbe4f906b5ad89a863c0b";
    hash = "sha256-UGssF6x/H5met7f2hC6str2urvCZRj/Oqp2R0rv2RUw=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
