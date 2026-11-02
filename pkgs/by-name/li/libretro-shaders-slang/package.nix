{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-08-25";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "4812a82f6c9a11cc8b5a7447040a98c9fc80c00e";
    hash = "sha256-SDjxvbhF4y1JBrwsHYhbjhM3YYbkY2YLmmRMG4CmADk=";
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
