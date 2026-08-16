{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vba-next";
  version = "0-unstable-2026-07-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vba-next";
    rev = "2b96fd3a77025f3083daf61126b1852d5e0eace7";
    hash = "sha256-09KSCGlmHNrftX86CVUUAAIHiOpM+MpWwa+XOw3MrJA=";
  };

  meta = {
    description = "VBA-M libretro port with modifications for speed";
    homepage = "https://github.com/libretro/vba-next";
    license = lib.licenses.gpl2Only;
  };
}
