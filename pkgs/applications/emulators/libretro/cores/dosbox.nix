{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "dosbox";
  version = "0-unstable-2022-07-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "dosbox-libretro";
    rev = "b7b24262c282c0caef2368c87323ff8c381b3102";
    hash = "sha256-PG2eElenlEpu0U/NIh53p0uLqewnEdaq6Aoak5E1P3I=";
  };

  env.CXXFLAGS = "-std=gnu++11";

  meta = {
    description = "Port of DOSBox to libretro";
    homepage = "https://github.com/libretro/dosbox-libretro";
    license = lib.licenses.gpl2Only;
  };
}
