{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-12-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "f5d06a93513e91f67254fe27effc5e95aebc1d4e";
    hash = "sha256-RdQwmasgq+nd1k/Fr2SOdElua/b2IG/6c/onOLlLZdM=";
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
