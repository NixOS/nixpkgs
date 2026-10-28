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
    runHook preInstall

    mkdir -p $out

    runHook postInstall
  '';

  meta = {
    description = "Dummy package for the libretro package set";
    # XXX: nixpkgs-merge-bot needs this package to evaluate clearly to allow
    # the individual cores to be merged, and that members that want to merge
    # via bot to be added to this list instead of each individual core.
    platforms = lib.platforms.all;
    teams = [ lib.teams.libretro ];
    maintainers = [ ];
  };
}
