{
  lib,
  stdenvNoCC,
}:

# The only reason this package exists is to pass nixpkgs-vet validations.
# https://github.com/NixOS/nixpkgs/pull/522287
stdenvNoCC.mkDerivation {
  pname = "libretroPackages";
  version = "0";

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  installPhase = ''
    echo >&2 "'libretroPackages' is a package set, not an installable package."
    echo >&2 "Use an individual core instead, e.g., 'libretro.mgba'."
    exit 1
  '';

  meta = {
    description = "Dummy package for the libretro package set";
    hydraPlatforms = [ ];
    # XXX: nixpkgs-merge-bot needs this package to evaluate clearly to allow
    # the individual cores to be merged, and that members that want to merge
    # via bot to be added to this list instead of each individual core.
    platforms = lib.platforms.all;
    teams = [ lib.teams.libretro ];
    members = [ ];
  };
}
