{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x";
  version = "0-unstable-2026-09-24";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = "1bcc369e89f08243e0a462882fb1f3e42e51de3a";
    hash = "sha256-9YK7SMHOU/v2eyzXMYb8iXhfdcQ4bDyLYE0E3j11OBI=";
  };

  patches = [
    # Bound the screenshot read when loading a save state
    # https://github.com/snes9xgit/snes9x/pull/1112
    ./snes9x-CVE-2026-134856.patch
  ];

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of SNES9x git to libretro";
    homepage = "https://github.com/snes9xgit/snes9x";
    license = lib.licenses.unfreeRedistributable;
  };
}
