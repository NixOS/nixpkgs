{
  lib,
  fetchFromGitHub,
  hexdump,
  mkLibretroCore,
  which,
}:
mkLibretroCore {
  core = "sameboy";
  version = "0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "sameboy";
    rev = "aa158a889a48b538a0302873704a34577c8eb67d";
    hash = "sha256-XVIPZsT4E1CQJnDHc+K4gmO2XVOaUxsoiasStcrf3tA=";
  };

  extraNativeBuildInputs = [
    which
    hexdump
  ];
  preBuild = "cd libretro";
  makefile = "Makefile";

  meta = {
    description = "SameBoy libretro port";
    homepage = "https://github.com/libretro/SameBoy";
    license = lib.licenses.mit;
  };
}
