{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "retroarch-assets";
<<<<<<< HEAD
  version = "1.22.0-unstable-2025-12-01";
=======
  version = "1.22.0-unstable-2025-11-10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-assets";
<<<<<<< HEAD
    rev = "a7b711dfd74871e9985ba3b2fe2c15048a928aaf";
    hash = "sha256-M0abYzsWxGHgwQEobhLKIIKj3XeDxmZBN+5+UER4c9k=";
=======
    rev = "76cc6cf03507429c5a136cb50d83a14e05430fcd";
    hash = "sha256-0kxgfuqBoqhT9/D04bHj0Nd0yUYJUa39rSoxTovV6xE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  makeFlags = [
    "PREFIX=$(out)"
    # By default install in $(PREFIX)/share/libretro/assets
    # that is not in RetroArch's assets path
    "INSTALLDIR=$(PREFIX)/share/retroarch/assets"
  ];

  dontBuild = true;

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

<<<<<<< HEAD
  meta = {
    description = "Assets needed for RetroArch";
    homepage = "https://libretro.com";
    license = lib.licenses.mit;
    teams = [ lib.teams.libretro ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Assets needed for RetroArch";
    homepage = "https://libretro.com";
    license = licenses.mit;
    teams = [ teams.libretro ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
