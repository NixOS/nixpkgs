/* Nix expression to test for regressions in the Haskell configuration overlays.

   test-configurations.nix determines all attributes touched by given Haskell
   configuration overlays (i. e. pkgs/development/haskell-modules/configuration-*.nix)
   and builds all derivations (or at least a reasonable subset) affected by
   these overrides.

   By default, it checks `configuration-{common,nix,ghc-8.10.x}.nix`. You can
   invoke it like this:

     nix-build maintainers/scripts/haskell/test-configurations.nix --keep-going

   It is possible to specify other configurations:

     nix-build maintainers/scripts/haskell/test-configurations.nix \
       --arg files '[ "configuration-ghc-9.0.x.nix" "configuration-ghc-9.2.x.nix" ]' \
       --keep-going

   You can also just supply a single string:

     nix-build maintainers/scripts/haskell/test-configurations.nix \
       --argstr files "configuration-arm.nix" --keep-going

   You can even supply full paths which is handy, as it allows for tab-completing
   the configurations:

     nix-build maintainers/scripts/haskell/test-configurations.nix \
       --argstr files pkgs/development/haskell-modules/configuration-arm.nix \
       --keep-going

   By default, derivation that fail to evaluate are skipped, unless they are
   “just” marked as broken. You can check for other eval errors like this:

     nix-build maintainers/scripts/haskell/test-configurations.nix \
       --arg skipEvalErrors false --keep-going

   You can also disable checking broken packages by passing a nixpkgs config:

     nix-build maintainers/scripts/haskell/test-configurations.nix \
       --arg config '{ allowBroken = false; }' --keep-going

   By default the haskell.packages.ghc*Binary sets used for bootstrapping GHC
   are _not_ tested. You can change this using:

     nix-build maintainers/scripts/haskell/test-configurations.nix \
       --arg skipBinaryGHCs false --keep-going

*/
{ files ? [
    "configuration-common.nix"
    "configuration-nix.nix"
    "configuration-ghc-8.10.x.nix"
  ]
, nixpkgsPath ? ../../..
, config ? { allowBroken = true; }
, skipEvalErrors ? true
, skipBinaryGHCs ? true
}:

let
  pkgs = import nixpkgsPath { inherit config; };
  inherit (pkgs) lib;

  # see usage explanation for the input format `files` allows
  files' = builtins.map builtins.baseNameOf (
    if !builtins.isList files then [ files ] else files
  );

  setsForFile = fileName:
    let
      # extract the unique part of the config's file name
      configName = builtins.head (
        builtins.match "configuration-(.+).nix" fileName
      );
      # match the major and minor version of the GHC the config is intended for, if any
      configVersion = lib.concatStrings (
        builtins.match "ghc-([0-9]+).([0-9]+).x" configName
      );
      # return all package sets under haskell.packages matching the version components
      setsForVersion =  builtins.map (name: pkgs.haskell.packages.${name}) (
        builtins.filter (setName:
          lib.hasPrefix "ghc${configVersion}" setName
          && (skipBinaryGHCs -> !(lib.hasInfix "Binary" setName))
        ) (
          builtins.attrNames pkgs.haskell.packages
        )
      );

      defaultSets = [ pkgs.haskellPackages ];
    in {
      # use plain haskellPackages for the version-agnostic files
      # TODO(@sternenseemann): also consider currently selected versioned sets
      "common" = defaultSets;
      "nix" = defaultSets;
      "arm" = defaultSets;
      "darwin" = defaultSets;
    }.${configName} or setsForVersion;

  # evaluate a configuration and only return the attributes changed by it
  overriddenAttrs = fileName: builtins.attrNames (
    import (nixpkgsPath + "/pkgs/development/haskell-modules/${fileName}") {
      haskellLib = pkgs.haskell.lib.compose;
      inherit pkgs;
    } {} {}
  );

  # list of derivations that are affected by overrides in the given configuration
  # overlays. For common, nix, darwin etc. only the derivation from the default
  # package set will be emitted.
  packages = builtins.filter (v:
    lib.warnIf (v.meta.broken or false) "${v.pname} is marked as broken" (
      v != null
      && (skipEvalErrors -> (builtins.tryEval (v.outPath or v)).success)
    )
  ) (
    lib.concatMap (fileName:
      let
        sets = setsForFile fileName;
        attrs = overriddenAttrs fileName;
      in
        lib.concatMap (set: builtins.map (attr: set.${attr}) attrs) sets
    ) files'
  );
in

packages
