# Utils for sweeping through packages based on some property discoverable at eval time
# Useful for narrowing down package candidates on which to test some build time property
#
# Example 1: finding packages with patches that no longer apply
#   nix-build sweep-packages.nix -A derivationsWith.overrideAttrs.patches --keep-going
# The desired packages are reported in the error message or on a subsequent `--dry-run`
#
# Example 2: finding packages with unnecessarily disabled test suite
#   nix-instantiate sweep-packages.nix -A derivationsWithout.overrideAttrs.doCheck | ./report-successes.sh
# Here we use `derivationsWithout` to reset the `doCheck` override and then look at builds that *don't* fail

{
  nixpkgs ? import ../../.. { }, # nixpkgs to obtain utils from
  pkgs ? nixpkgs.haskellPackages, # package set to sweep
}:

with nixpkgs;

rec {
  inherit pkgs lib;

  id = x: x;

  canEval = v: (builtins.tryEval v.outPath).success;

  isValidPackage =
    n: v:
    lib.all id [
      (n != "ghc")
      (!(v.meta.broken or true))
      ((v.meta.hydraPlatforms or null) != [ ])
    ];

  original = lens: lib.filterAttrs (n: v: isValidPackage n v && lens.get v) pkgs;

  modified =
    modify: lens:
    lib.pipe (original lens) [
      (builtins.mapAttrs (_: modify lens))
      (lib.filterAttrs (_: canEval))
    ];

  lenses = {
    overrideAttrs = {
      doCheck = rec {
        get = v: !(v.doCheck or true);
        set = x: v: v.overrideAttrs { doCheck = x; };
        reset = set true;
      };

      patches = rec {
        get = v: v.patches != [ ];
        set = x: v: v.overrideAttrs { patches = x; };
        reset = set [ ];
      };
    };

    overrideCabal = with haskell.lib.compose; {
      doHaddock = rec {
        get = v: v.isHaskellLibrary && !(lib.hasInfix "Setup haddock" v.haddockPhase);
        set = x: overrideCabal { doHaddock = x; };
        reset = set true;
      };

      jailbreak = rec {
        get = v: lib.hasInfix "jailbreak-cabal" v.postPatch;
        set = x: overrideCabal { jailbreak = x; };
        reset = set false;
      };

      enableParallelBuilding = rec {
        get = v: !lib.hasInfix "-j$NIX_BUILD_CORES" v.setupCompilerEnvironmentPhase;
        set = x: overrideCabal { enableParallelBuilding = x; };
        reset = set true;
      };
    };
  };

  sweep = f: builtins.mapAttrs (_: builtins.mapAttrs (_: modified f)) lenses;

  derivationsWithout = sweep (l: l.reset);
  derivationsWith = sweep (_: id);
}
