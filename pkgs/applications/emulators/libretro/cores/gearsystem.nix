{
  lib,
  fetchFromGitHub,
  gitMinimal,
  mkLibretroCore,
}:

mkLibretroCore {
  core = "gearsystem";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "drhelius";
    repo = "gearsystem";
    tag = "gearsystem-3.4.1";
    hash = "sha256-o7vSSrMimbOL0BMi9GtgGsYD0wTJTaq4kWuD3yEDcZM=";
  };

  sourceRoot = "source/platforms/libretro";
  makefile = "Makefile";

  extraNativeBuildInputs = [ gitMinimal ];

  postPatch = ''
    chmod -R u+w ../..
  '';

  meta = {
    description = "Sega Master System, Game Gear, and SG-1000 emulator core for libretro";
    homepage = "https://github.com/drhelius/gearsystem";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
