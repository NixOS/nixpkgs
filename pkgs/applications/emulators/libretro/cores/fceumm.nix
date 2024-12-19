{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2024-11-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "449db5de6b56e9d44fc685e1b38399f0b233bd28";
    hash = "sha256-yD75ohq7dJwXt6t3RLMwTtmdLGLS3/eb98uBlnazWDk=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
