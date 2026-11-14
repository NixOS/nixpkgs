{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-database";
  version = "1.22.1-unstable-2026-09-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-database";
    rev = "d5bae90b22018ce3c9c5a8eff4141a4768c8dd5f";
    hash = "sha256-acbQgw3G5RwVzEGll82//dKA4pP/47R2kIJ4Ty4p/ME=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;
  dontBuild = true;

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    install -Dm644 LICENSE "$out/share/licenses/libretro-database/LICENSE"
    install -Dm644 README.md "$out/share/doc/libretro-database/README.md"
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    description = "Game databases, cheat codes and database cursors for RetroArch";
    homepage = "https://github.com/libretro/libretro-database";
    license = lib.licenses.cc-by-sa-40;
    teams = [ lib.teams.libretro ];
    platforms = lib.platforms.all;
  };
}
