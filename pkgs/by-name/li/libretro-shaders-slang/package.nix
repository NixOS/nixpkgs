{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
<<<<<<< HEAD
  version = "0-unstable-2025-12-27";
=======
  version = "0-unstable-2025-11-19";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
<<<<<<< HEAD
    rev = "e24402e35d762a017127f44701cad8d3f4704f44";
    hash = "sha256-yv0MM90ACG5JGf9ypkyK3xlr6V284F/PrPAbXjuLZWw=";
=======
    rev = "279b031c92c7a376be47ffdec5fe669fb5dcebc0";
    hash = "sha256-0OltcN4W0vp7jtDSSIJ2ZanFi5p/efnPDOhaurr3ShY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
