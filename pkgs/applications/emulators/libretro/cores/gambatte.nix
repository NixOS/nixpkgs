{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "9f591132e67f101780495a43df8da9bca43e08db";
    hash = "sha256-wauSnUlZRAtZwheONd+NusM0D1q2pLwha6H90R4R1aU=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
