{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "retroarch-assets";
  version = "1.20.0-unstable-2025-05-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-assets";
    rev = "2d24ef2972a709f870cc3f73853158fa2376f37d";
    hash = "sha256-8FtY9W51Y0cLD61GHGz83TWoSyUuRfXEaAuEBKcFKRU=";
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

  meta = with lib; {
    description = "Assets needed for RetroArch";
    homepage = "https://libretro.com";
    license = licenses.mit;
    teams = [ teams.libretro ];
    platforms = platforms.all;
  };
}
