{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-04-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "f1b85fef8c82ae05bf24a2bda8eb2730b3b7023e";
    hash = "sha256-wAsU07lEjr9rFfW1WrnzflEriGwr/vzKpE9OM2zsPJA=";
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
