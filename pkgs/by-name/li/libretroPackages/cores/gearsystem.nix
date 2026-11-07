{
  lib,
  fetchFromGitHub,
  gitMinimal,
  mkLibretroCore,
}:

mkLibretroCore {
  core = "gearsystem";
  version = "3.9.12";

  src = fetchFromGitHub {
    owner = "drhelius";
    repo = "gearsystem";
    tag = "3.9.12";
    hash = "sha256-KMPhP8VHqDIGVTzmLo0a5HM84Wlef41whiXR3S9YQ0M=";
  };

  sourceRoot = "source/platforms/libretro";
  makefile = "Makefile";

  extraNativeBuildInputs = [ gitMinimal ];

  postPatch = ''
    # The libretro Makefile writes object files outside sourceRoot.
    chmod -R u+w ../../src ../shared/dependencies
  '';

  meta = {
    description = "Sega Master System, Game Gear, and SG-1000 emulator core for libretro";
    homepage = "https://github.com/drhelius/gearsystem";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
