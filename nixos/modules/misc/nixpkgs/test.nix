{ evalMinimalConfig, pkgs, lib, stdenv }:
let
  eval = mod: evalMinimalConfig {
    imports = [ ../nixpkgs.nix mod ];
  };
  withHost = eval {
    nixpkgs.hostPlatform = "aarch64-linux";
  };
  withHostAndBuild = eval {
    nixpkgs.hostPlatform = "aarch64-linux";
    nixpkgs.buildPlatform = "aarch64-darwin";
  };
  ambiguous = {
    _file = "ambiguous.nix";
    nixpkgs.hostPlatform = "aarch64-linux";
    nixpkgs.buildPlatform = "aarch64-darwin";
    nixpkgs.system = "x86_64-linux";
    nixpkgs.localSystem.system = "x86_64-darwin";
    nixpkgs.crossSystem.system = "i686-linux";
    imports = [
      { _file = "repeat.nix";
        nixpkgs.hostPlatform = "aarch64-linux";
      }
    ];
  };
  getErrors = module:
    let
      uncheckedEval = lib.evalModules { modules = [ ../nixpkgs.nix module ]; };
    in map (ass: ass.message) (lib.filter (ass: !ass.assertion) uncheckedEval.config.assertions);
in
lib.recurseIntoAttrs {
  invokeNixpkgsSimple =
    (eval {
      nixpkgs.system = stdenv.hostPlatform.system;
    })._module.args.pkgs.hello;
  assertions =
    assert withHost._module.args.pkgs.stdenv.hostPlatform.system == "aarch64-linux";
    assert withHost._module.args.pkgs.stdenv.buildPlatform.system == "aarch64-linux";
    assert withHostAndBuild._module.args.pkgs.stdenv.hostPlatform.system == "aarch64-linux";
    assert withHostAndBuild._module.args.pkgs.stdenv.buildPlatform.system == "aarch64-darwin";
    assert builtins.trace (lib.head (getErrors ambiguous))
      getErrors ambiguous ==
        [''
          Your system configures nixpkgs with the platform parameters:
          nixpkgs.hostPlatform, with values defined in:
            - repeat.nix
            - ambiguous.nix
          nixpkgs.buildPlatform, with values defined in:
            - ambiguous.nix

          However, it also defines the legacy options:
          nixpkgs.system, with values defined in:
            - ambiguous.nix
          nixpkgs.localSystem, with values defined in:
            - ambiguous.nix
          nixpkgs.crossSystem, with values defined in:
            - ambiguous.nix

          For a future proof system configuration, we recommend to remove
          the legacy definitions.
        ''];
    assert getErrors {
        nixpkgs.localSystem = pkgs.stdenv.hostPlatform;
        nixpkgs.hostPlatform = pkgs.stdenv.hostPlatform;
        nixpkgs.pkgs = pkgs;
      } == [];

    pkgs.emptyFile;
}
