{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "b6501536eb7c9de3a41693143254cb021c89e77a";
    hash = "sha256-gjG/IFthh5cQotc90SgJ8Ei7R/NhoBvjI43K+JhV9v4=";
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
