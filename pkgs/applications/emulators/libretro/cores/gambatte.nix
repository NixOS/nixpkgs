{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-02-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "041833eb4b28e349f7690e18d04a5d7f28639bd1";
    hash = "sha256-wC5wMCd5LDrNZgGTtAvg5asyPK7wlK/+DhUOgqvZvXs=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
