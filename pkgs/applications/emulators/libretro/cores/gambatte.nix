{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-06-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "811b1f7a56c16f8588caada36d7a3f9a56cb16d4";
    hash = "sha256-pPLUvlwRoVMRcCGyxqot2QAanKmQWknk5uF4rRZ41zY=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
