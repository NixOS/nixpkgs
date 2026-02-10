{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-02-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "476a4c7226f87dca4ed67635746ebfaa91851a82";
    hash = "sha256-zO9/9OEU5TMokjPdvkKtB4LI/Bf+mDQOtsg0k9dZ99c=";
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
