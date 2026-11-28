{
  lib,
  fetchFromGitHub,
  gitMinimal,
  gitUpdater,
  mkLibretroCore,
}:

mkLibretroCore (finalAttrs: {
  core = "gearcoleco";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "drhelius";
    repo = "Gearcoleco";
    tag = finalAttrs.version;
    hash = "sha256-0/vTbf9ELoBv1A2bwAb6G0jxpx/AhNucVsA9JiKH0vA=";
  };

  sourceRoot = "source/platforms/libretro";
  makefile = "Makefile";

  extraNativeBuildInputs = [ gitMinimal ];

  postPatch = ''
    # The libretro Makefile writes object files outside sourceRoot.
    chmod -R u+w ../../src ../shared/dependencies/miniz
  '';

  # mkLibretroCore defaults to unstableGitUpdater, which expects a `rev`
  passthru.updateScript = gitUpdater { };

  meta = {
    description = "ColecoVision emulator core for libretro";
    homepage = "https://github.com/drhelius/Gearcoleco";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
})
