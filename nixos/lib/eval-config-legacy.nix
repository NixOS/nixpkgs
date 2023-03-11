# This module encapsulates the legacy nixos eval entrypoint
# in order to clean up the main entrypoint and make
# a small step towards actual deprecation
{ lib, evalConfigArgs }: let
  _file = ./eval-config-legacy.nix;
  key = _file;
in {

  legacyModules =
    lib.optional (evalConfigArgs?extraArgs) {
      config._module.args = evalConfigArgs.extraArgs;
      inherit key _file;
    }
    ++ lib.optional (evalConfigArgs?check) {
      config._module.check = lib.mkDefault evalConfigArgs.check;
      inherit key _file;
    };

  legacyPkgsModules = let
    # Explicit `nixpkgs.system` or `nixpkgs.localSystem` should override
    # this.  Since the latter defaults to the former, the former should
    # default to the argument. That way this new default could propagate all
    # they way through, but has the last priority behind everything else.
    mkDefaultSystem = lib.mkDefault;
  in
    lib.optional (evalConfigArgs?system) {
      config.nixpkgs.system = mkDefaultSystem evalConfigArgs.system;
      inherit key _file;
    }
    # legacy impure entrypoint shim
    ++ lib.optional (!evalConfigArgs?system && builtins?currentSystem) {
      config.nixpkgs.system = mkDefaultSystem builtins.currentSystem;
      inherit key _file;
    }
    ++ lib.optional (evalConfigArgs?pkgs) {
      _module.args.pkgs = lib.mkForce evalConfigArgs.pkgs;
      inherit key _file;
    };
}
