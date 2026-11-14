{
  lib,
  fetchFromGitHub,
  gitUpdater,
  mkLibretroCore,
}:
mkLibretroCore (finalAttrs: {
  core = "virtualjaguar";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "virtualjaguar-libretro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UaRk6BxjtMEoygyor1SwzCAhtMSz3GullKvvSqGztJw=";
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
