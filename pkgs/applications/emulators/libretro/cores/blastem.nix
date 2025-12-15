{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "blastem";
  version = "0-unstable-2022-07-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "blastem";
    rev = "277e4a62668597d4f59cadda1cbafb844f981d45";
    hash = "sha256-EHvKElPw8V5Z6LnMaQXBCdM4niLIlF3aBm8dRbeYXHs=";
  };

  meta = {
    description = "Port of BlastEm to libretro";
    homepage = "https://github.com/libretro/blastem";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.x86;
  };
}
