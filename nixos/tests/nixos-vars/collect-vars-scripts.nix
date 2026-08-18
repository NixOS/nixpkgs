# The vars CLI needs to call Nix at runtime. This would usually fail inside a
# NixOS test, as the VM has no network access.
#
# This module takes a NixOS configuration, collects every vars-related
# derivation, and returns their combined closures. Said closure can later be
# added to `system.extraDependencies`.
{ pkgs, configuration }:
let
  inherit (pkgs) lib;
  evaluated = pkgs.nixos-vars.jsonify {
    inherit configuration;
    pkgsHost = pkgs;
    pkgsTarget = pkgs;
  };
  derivations = [
    (lib.mapAttrsToList (_: x: [
      x.delete
      x.deploy.local
      x.deploy.remote
      x.exists
      x.fixup
      x.get
      x.list
      x.set
    ]) evaluated.generatorBackends)
    (lib.mapAttrsToList (_: x: x.script) evaluated.promptBackends)
    (lib.mapAttrsToList (_: x: x.script) evaluated.generators)
  ];
in
pkgs.closureInfo {
  rootPaths = lib.lists.filter (x: x != null) (lib.lists.flatten derivations);
}
