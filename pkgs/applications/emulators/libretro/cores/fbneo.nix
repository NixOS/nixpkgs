{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-03-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "14ff80a2e0611d039321a3ac0dd76bf6b4e3210f";
    hash = "sha256-L6KYyEb95L9rDnaMVh49afaWxsshTy3eujsTQWbPfl0=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
