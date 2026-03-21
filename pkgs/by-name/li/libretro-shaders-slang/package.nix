{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-03-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "875bc1da241f4d174e6443c754e7dd4926f76f8c";
    hash = "sha256-N/JZ8qTJtg/RlWnQXJ9SJruz7zr5yHJdWL+XnxxMM84=";
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
