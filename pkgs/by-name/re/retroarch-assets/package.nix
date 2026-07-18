{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "retroarch-assets";
  version = "1.22.0-unstable-2026-06-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-assets";
    rev = "a12a7be0898de32ab3eefb891e6778ff5130e5fb";
    hash = "sha256-Mhp9+Mr/M79ZqIt9H6RrciOH+bE1cI5TLTjGzz4zKrw=";
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
