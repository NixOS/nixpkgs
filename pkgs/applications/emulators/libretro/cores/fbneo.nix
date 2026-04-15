{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-04-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "e869c6a2033b135e7fcbea4a50695e97755feae1";
    hash = "sha256-YIva50UWylsDmAaJZI85LCphrgjh7jDYQZkpAlQr1HM=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
