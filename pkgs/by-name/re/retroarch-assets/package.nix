{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "retroarch-assets";
  version = "1.22.0-unstable-2026-08-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-assets";
    rev = "6a1bbdeff5bca537a5712e2226a2aeeaee211fd0";
    hash = "sha256-BZyGCveK4h/T2toveGeeKwM6PnZurZLq9URzzf6mfmw=";
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

  meta = {
    description = "Assets needed for RetroArch";
    homepage = "https://libretro.com";
    license = lib.licenses.mit;
    teams = [ lib.teams.libretro ];
    platforms = lib.platforms.all;
  };
}
