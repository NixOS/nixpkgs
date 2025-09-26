/*
  Nix expression to test for regressions in the Haskell configuration overlays.

  test-configurations.nix determines all attributes touched by given Haskell
  configuration overlays (i. e. pkgs/development/haskell-modules/configuration-*.nix)
  and builds all derivations (or at least a reasonable subset) affected by
  these overrides.

  By default, it checks `configuration-{common,nix,ghc-9.8.x}.nix`. You can
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
{
  files ? [
    "configuration-common.nix"
    "configuration-nix.nix"
    "configuration-ghc-9.8.x.nix"
  ],
  nixpkgsPath ? ../../..,
  config ? {
    allowBroken = true;
  },
  skipEvalErrors ? true,
  skipBinaryGHCs ? true,
}:

let
  pkgs = import nixpkgsPath { inherit config; };
  inherit (pkgs) lib;

  # see usage explanation for the input format `files` allows
  files' = builtins.map builtins.baseNameOf (if !builtins.isList files then [ files ] else files);

  packageSetsWithVersionedHead =
    pkgs.haskell.packages
    // (
      let
        headSet = pkgs.haskell.packages.ghcHEAD;
        # Determine the next GHC release version following GHC HEAD.
        # GHC HEAD always has an uneven, tentative version number, e.g. 9.7.
        # GHC releases always have even numbers, i.e. GHC 9.8 is branched off from
        # GHC HEAD 9.7. Since we use the to be release number for GHC HEAD's
        # configuration file, we need to calculate this here.
        headVersion = lib.pipe headSet.ghc.version [
          lib.versions.splitVersion
          (lib.take 2)
          lib.concatStrings
          lib.strings.toInt
          (builtins.add 1)
          toString
        ];
      in
      {
        "ghc${headVersion}" = headSet;
      }
    );

  setsForFile =
    fileName:
    let
      # extract the unique part of the config's file name
      configName = builtins.head (builtins.match "configuration-(.+).nix" fileName);
      # match the major and minor version of the GHC the config is intended for, if any
      configVersion = lib.concatStrings (builtins.match "ghc-([0-9]+).([0-9]+).x" configName);
      # return all package sets under haskell.packages matching the version components
      setsForVersion = builtins.map (name: packageSetsWithVersionedHead.${name}) (
        builtins.filter (
          setName:
          lib.hasPrefix "ghc${configVersion}" setName && (skipBinaryGHCs -> !(lib.hasInfix "Binary" setName))
        ) (builtins.attrNames packageSetsWithVersionedHead)
      );

      defaultSets = [ pkgs.haskellPackages ];
    in
    {
      # use plain haskellPackages for the version-agnostic files
      # TODO(@sternenseemann): also consider currently selected versioned sets
      "common" = defaultSets;
      "nix" = defaultSets;
      "arm" = defaultSets;
      "darwin" = defaultSets;
    }
    .${configName} or setsForVersion;

  # attribute set that has all the attributes of haskellPackages set to null
  availableHaskellPackages = builtins.listToAttrs (
    builtins.map (attr: lib.nameValuePair attr null) (builtins.attrNames pkgs.haskellPackages)
  );

  # evaluate a configuration and only return the attributes changed by it,
  # pass availableHaskellPackages as super in case intersectAttrs is used
  overriddenAttrs =
    fileName:
    builtins.attrNames (
      lib.fix (
        self:
        import (nixpkgsPath + "/pkgs/development/haskell-modules/${fileName}") {
          haskellLib = pkgs.haskell.lib.compose;
          inherit pkgs;
        } self availableHaskellPackages
      )
    );

  # list of derivations that are affected by overrides in the given configuration
  # overlays. For common, nix, darwin etc. only the derivation from the default
  # package set will be emitted.
  packages =
    builtins.filter
      (
        v:
        lib.warnIf (v.meta.broken or false) "${v.pname} is marked as broken" (
          v != null && (skipEvalErrors -> (builtins.tryEval (v.outPath or v)).success)
        )
      )
      (
        lib.concatMap (
          fileName:
          let
            sets = setsForFile fileName;
            attrs = overriddenAttrs fileName;
          in
          lib.concatMap (set: builtins.map (attr: set.${attr}) attrs) sets
        ) files'
      );
in

packages
