{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:

stdenvNoCC.mkDerivation {
  strictDeps = true;
  __structuredAttrs = true;
  pname = "gershwin-assets";
  version = "0-unstable-2026-02-01";
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "gershwin-desktop";
    repo = "gershwin-assets";
    rev = "9266b6edd28ce7fb6d9e6dfcf9cca4cc4b1c3038";
    hash = "sha256-Scc33jaG/lJqEjunU9MGKGIM47YgRACoipsWsnPe2U8=";
  };

  env.DESTDIR = placeholder "out";

  meta = {
    homepage = "https://github.com/gershwin-desktop/gershwin-assets";
    description = "Assets for the Gershwin Desktop";
    maintainers = with lib.maintainers; [
      OulipianSummer
    ];
  };
  platforms = lib.platforms.linux;
}
