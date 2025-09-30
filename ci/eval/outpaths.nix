#!/usr/bin/env nix-shell
# When using as a callable script, passing `--argstr path some/path` overrides $PWD.
#!nix-shell -p nix -i "nix-env -qaP --no-name --out-path -f ci/eval/outpaths.nix"

{
  includeBroken ? true, # set this to false to exclude meta.broken packages from the output
  path ? ./../..,

  # used by ./attrpaths.nix
  attrNamesOnly ? false,

  # Set this to `null` to build for builtins.currentSystem only
  systems ? builtins.fromJSON (builtins.readFile ../supportedSystems.json),
}:
let
  lib = import (path + "/lib");

  nixpkgsJobs =
    import (path + "/pkgs/top-level/release.nix")
      # Compromise: accuracy vs. resources needed for evaluation.
      {
        inherit attrNamesOnly;
        supportedSystems = if systems == null then [ builtins.currentSystem ] else systems;
        nixpkgsArgs = {
          config = {
            allowAliases = false;
            allowBroken = includeBroken;
            allowUnfree = true;
            allowInsecurePredicate = x: true;
            allowVariants = !attrNamesOnly;
            checkMeta = true;

            handleEvalIssue =
              reason: errormsg:
              let
                fatalErrors = [
                  "unknown-meta"
                  "broken-outputs"
                ];
              in
              if builtins.elem reason fatalErrors then
                abort errormsg
              # hydra does not build unfree packages, so tons of them are broken yet not marked meta.broken.
              else if
                !includeBroken
                && builtins.elem reason [
                  "broken"
                  "unfree"
                ]
              then
                throw "broken"
              else if builtins.elem reason [ "unsupported" ] then
                throw "unsupported"
              else
                true;

            inHydra = true;
          };

          __allowFileset = false;
        };
      };

  nixosJobs = import (path + "/nixos/release.nix") {
    inherit attrNamesOnly;
    supportedSystems = if systems == null then [ builtins.currentSystem ] else systems;
  };

  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  # release-lib leaves recurseForDerivations as empty attrmaps;
  # that would break nix-env and we also need to recurse everywhere.
  tweak = lib.mapAttrs (
    name: val:
    if name == "recurseForDerivations" then
      true
    else if lib.isAttrs val && val.type or null != "derivation" then
      recurseIntoAttrs (tweak val)
    else
      val
  );

  # Some of these contain explicit references to platform(s) we want to avoid;
  # some even (transitively) depend on ~/.nixpkgs/config.nix (!)
  blacklist = [
    "tarball"
    "metrics"
    "manual"
    "darwin-tested"
    "unstable"
    "stdenvBootstrapTools"
    "moduleSystem"
    "lib-tests" # these just confuse the output
  ];

in
tweak (
  (removeAttrs nixpkgsJobs blacklist)
  // {
    nixosTests.simple = nixosJobs.tests.simple;
  }
)
