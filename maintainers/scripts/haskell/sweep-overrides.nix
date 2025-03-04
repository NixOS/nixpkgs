property:
{
  pkgs ? import ../../.. { }, # nixpkgs to obtain utils from
  haskellPackages ? pkgs.haskellPackages, # haskell package set to build from
}:

with pkgs;
with haskell.lib.compose;

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

  original = lens: lib.filterAttrs (n: v: isValidPackage n v && lens.get v) haskellPackages;

  modified =
    lens:
    lib.pipe (original lens) [
      (builtins.mapAttrs (_: lens.reset))
      (lib.filterAttrs (_: canEval))
    ];

  lenses = {
    doCheck = rec {
      get = v: !(v.doCheck or true);
      set = x: overrideCabal { doCheck = x; };
      reset = set true;
    };

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
  };

  derivations =
    assert lib.assertOneOf "property" property (builtins.attrNames lenses);
    modified lenses.${property};
}
