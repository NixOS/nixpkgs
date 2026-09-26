{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prosystem";
  version = "0-unstable-2026-08-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "prosystem-libretro";
    rev = "8a88014287c7a01cd568067e5a557d0a2b2a051f";
    hash = "sha256-xvfx/bypYiPal92v4m7xBRtnlKzYYtDXyRFebJpAVQQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of ProSystem to libretro";
    homepage = "https://github.com/libretro/prosystem-libretro";
    license = lib.licenses.gpl2Only;
  };
}
