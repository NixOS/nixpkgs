{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-08-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "69e3dbb8947e749156ff1f70e32c88f3c37e6793";
    hash = "sha256-C+qO/B3Lb8vtQUV3u6ZqiVZlg2prytR+9IbTnvyQGMg=";
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
