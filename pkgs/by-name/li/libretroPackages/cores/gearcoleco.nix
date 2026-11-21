{
  lib,
  fetchFromGitHub,
  gitMinimal,
  gitUpdater,
  mkLibretroCore,
}:

mkLibretroCore (finalAttrs: {
  core = "gearcoleco";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "drhelius";
    repo = "Gearcoleco";
    tag = finalAttrs.version;
    hash = "sha256-5ZjA0ZHqha5rubYTG2HkrAreDddeCiG+7cf62V043L0=";
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
