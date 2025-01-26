{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mesen";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mesen";
    rev = "791c5e8153ee6e29691d45b5df2cf1151ff416f9";
    hash = "sha256-PEEGJsyT+D/JwBxH2H9OY2MwaGt1i+1kmDZUT6zROic=";
  };

  makefile = "Makefile";
  preBuild = "cd Libretro";

  meta = {
    description = "Port of Mesen to libretro";
    homepage = "https://github.com/libretro/mesen";
    license = lib.licenses.gpl3Only;
  };
}
