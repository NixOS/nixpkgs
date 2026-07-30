{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-07-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "9b3b5e3cc18ec92f460d37dd551eaf90c55bfcea";
    hash = "sha256-IBQmVcWx839rRV8uLUou4fdwxgZqVbMWyqRVa3Dq0rc=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
