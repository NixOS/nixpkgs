{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mgba";
  version = "0-unstable-2025-01-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mgba";
    rev = "72b5a9d3c4945c381d3230d59ea484729bcfe6c7";
    hash = "sha256-90APQtjwYh/KPrvvlnVU+3G45gaibpOEBf9MoVWOzDI=";
  };

  meta = {
    description = "Port of mGBA to libretro";
    homepage = "https://github.com/libretro/mgba";
    license = lib.licenses.mpl20;
  };
}
