{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-03-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "e574b50f6ebb97ea5f49a55ad2312e1fe4ef0952";
    hash = "sha256-lH9WKD9Rox9DNrDCxilqA5zh60i0MdHsuGBoHHiITLg=";
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
