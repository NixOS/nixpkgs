{
  lib,
  fetchFromGitHub,
  gitUpdater,
  mkLibretroCore,
}:
mkLibretroCore (finalAttrs: {
  core = "virtualjaguar";
  version = "3.13.1";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "virtualjaguar-libretro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dF+uUy32ycieE+scQXfCMNzLqhW1Sad+4myR031J+rY=";
  };

  postPatch = ''
    patchShebangs scripts
  '';

  makefile = "Makefile";

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Port of VirtualJaguar to libretro";
    homepage = "https://github.com/libretro/virtualjaguar-libretro";
    changelog = "https://github.com/libretro/virtualjaguar-libretro/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
  };
})
