{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-08-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "c9303dcc4d11fe5d37db9ef9a24c8eab4087c0c3";
    hash = "sha256-k/th5Ze/x48mTFZxEsSWCE4STnMSFXl3I0uMVmdMSxc=";
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
