{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-12-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "b80bba0c71e98250717acc5f4e6b9bb9f75bd091";
    hash = "sha256-CSe7tP8N1ubZ5igjoLpi/w3XmbH3tGpbjBfI4i9pd5o=";
  };

  dontConfigure = true;
  dontBuild = true;
  installFlags = "PREFIX=${placeholder "out"}";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Slang shaders for use with RetroArch's shader system";
    homepage = "https://github.com/libretro/slang-shaders";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nadiaholmquist ];
    platforms = lib.platforms.all;
  };
}
