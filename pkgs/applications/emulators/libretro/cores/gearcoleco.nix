{
  lib,
  fetchFromGitHub,
  gitMinimal,
  mkLibretroCore,
}:

mkLibretroCore {
  core = "gearcoleco";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "drhelius";
    repo = "Gearcoleco";
    tag = "1.6.6";
    hash = "sha256-4zxHejYWlmVpeLxlTpbYSA34ICUBjiEXrH0WyWygdj8=";
  };

  sourceRoot = "source/platforms/libretro";
  makefile = "Makefile";

  extraNativeBuildInputs = [ gitMinimal ];

  postPatch = ''
    chmod -R u+w ../..
  '';

  meta = {
    description = "ColecoVision emulator core for libretro";
    homepage = "https://github.com/drhelius/Gearcoleco";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
