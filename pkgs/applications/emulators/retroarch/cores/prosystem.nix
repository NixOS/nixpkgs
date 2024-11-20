{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prosystem";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "prosystem-libretro";
    rev = "acae250da8d98b8b9707cd499e2a0bf6d8500652";
    hash = "sha256-AGF3K3meZEEsnzHmMTCsFXBGNvWVELH8a8qET07kP0o=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of ProSystem to libretro";
    homepage = "https://github.com/libretro/prosystem-libretro";
    license = lib.licenses.gpl2Only;
  };
}
