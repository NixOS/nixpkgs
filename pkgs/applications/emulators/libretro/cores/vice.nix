{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-07-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "f98f16ca1950b930d233cb0de24e181f0b7b5e14";
    hash = "sha256-X58uKqtlm8dW1aexBuBF8PLVAcaGyhZjeLH3+dkeDns=";
  };

  makefile = "Makefile";

  env = {
    EMUTYPE = "${type}";
  };

  meta = {
    description = "Port of vice to libretro";
    homepage = "https://github.com/libretro/vice-libretro";
    license = lib.licenses.gpl2;
  };
}
