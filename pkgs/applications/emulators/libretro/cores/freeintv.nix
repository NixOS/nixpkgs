{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "freeintv";
  version = "0-unstable-2025-12-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "freeintv";
    rev = "df5a5312985b66b1ec71b496868641e40b7ad1c9";
    hash = "sha256-xpcDAvxHvnuiQiWBYSwPKGE+Zg1lcs/6L4hMhpb1G1g=";
  };

  makefile = "Makefile";

  meta = {
    description = "FreeIntv libretro port";
    homepage = "https://github.com/libretro/freeintv";
    license = lib.licenses.gpl3Only;
  };
}
