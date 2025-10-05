{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "thepowdertoy";
  version = "0-unstable-2025-09-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "ThePowderToy";
    rev = "cb3cd4c2e5beddb98b34e6b800fa24e8f96322d9";
    hash = "sha256-k3XWkkSuQC3IBhhI96qkTrlGH/oJu941HaAvR28V5i0=";
  };

  extraNativeBuildInputs = [ cmake ];
  makefile = "Makefile";
  postBuild = "cd src";

  meta = {
    description = "Port of The Powder Toy to libretro";
    homepage = "https://github.com/libretro/ThePowderToy";
    license = lib.licenses.gpl3Only;
  };
}
