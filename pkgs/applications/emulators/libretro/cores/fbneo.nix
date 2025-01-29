{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2024-10-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "d72f49f4a45dbfc5a855956d1a75ce2d0601c1c5";
    hash = "sha256-+T+HQo6IfY8+oE/mOg54Vn9NhasGYNCLXksFdSDT/xE=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
