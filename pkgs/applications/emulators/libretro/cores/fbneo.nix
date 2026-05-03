{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-04-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "806cbc866c973caf442b4b6c6058f867b36bd1fb";
    hash = "sha256-kHB2Zz6mjhZiYDtoMIuaFvB2C/RIU89e2JNeBzHgIuU=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
