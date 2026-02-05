{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-01-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "9fe223d9c4b615c55840170c6e85e6e9fa4bd1d2";
    hash = "sha256-BBFT8+TLf5qbwo36BudPjeMRPLdSj2+0m4RnfeFrlOc=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
