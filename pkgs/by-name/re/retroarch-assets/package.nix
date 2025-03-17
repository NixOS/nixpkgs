{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "retroarch-assets";
  version = "1.20.0-unstable-2025-03-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-assets";
    rev = "fb39cdde6dfaea2c98218d28c71b14afc632fa03";
    hash = "sha256-2ytGtoci0xd10KrYGwMsGbXoT402DiokSVlCek8nhyI=";
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
    maintainers = with maintainers; teams.libretro.members ++ [ ];
    platforms = platforms.all;
  };
}
