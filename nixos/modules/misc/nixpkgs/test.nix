# [nixpkgs]$ nix-build -A nixosTests.nixpkgs --show-trace

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
  withSameHostAndBuild = eval {
    nixpkgs.hostPlatform = "aarch64-linux";
    nixpkgs.buildPlatform = "aarch64-linux";
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

  readOnlyUndefined = evalMinimalConfig {
    imports = [ ./read-only.nix ];
  };

  readOnlyBad = evalMinimalConfig {
    imports = [ ./read-only.nix ];
    nixpkgs.pkgs = { };
  };

  readOnly = evalMinimalConfig {
    imports = [ ./read-only.nix ];
    nixpkgs.pkgs = pkgs;
  };

  readOnlyBadConfig = evalMinimalConfig {
    imports = [ ./read-only.nix ];
    nixpkgs.pkgs = pkgs;
    nixpkgs.config.allowUnfree = true; # do in pkgs instead!
  };

  readOnlyBadOverlays = evalMinimalConfig {
    imports = [ ./read-only.nix ];
    nixpkgs.pkgs = pkgs;
    nixpkgs.overlays = [ (_: _: {}) ]; # do in pkgs instead!
  };

  readOnlyBadHostPlatform = evalMinimalConfig {
    imports = [ ./read-only.nix ];
    nixpkgs.pkgs = pkgs;
    nixpkgs.hostPlatform = "foo-linux"; # do in pkgs instead!
  };

  readOnlyBadBuildPlatform = evalMinimalConfig {
    imports = [ ./read-only.nix ];
    nixpkgs.pkgs = pkgs;
    nixpkgs.buildPlatform = "foo-linux"; # do in pkgs instead!
  };

  throws = x: ! (builtins.tryEval x).success;

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
    assert withSameHostAndBuild.config.nixpkgs.buildPlatform == withSameHostAndBuild.config.nixpkgs.hostPlatform;
    assert withSameHostAndBuild._module.args.pkgs.stdenv.buildPlatform == withSameHostAndBuild._module.args.pkgs.stdenv.hostPlatform;
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


    # Tests for the read-only.nix module
    assert readOnly._module.args.pkgs.stdenv.hostPlatform.system == pkgs.stdenv.hostPlatform.system;
    assert throws readOnlyBad._module.args.pkgs.stdenv;
    assert throws readOnlyUndefined._module.args.pkgs.stdenv;
    assert throws readOnlyBadConfig._module.args.pkgs.stdenv;
    assert throws readOnlyBadOverlays._module.args.pkgs.stdenv;
    assert throws readOnlyBadHostPlatform._module.args.pkgs.stdenv;
    assert throws readOnlyBadBuildPlatform._module.args.pkgs.stdenv;
    # read-only.nix does not provide legacy options, for the sake of simplicity
    # If you're bothered by this, upgrade your configs to use the new *Platform
    # options.
    assert !readOnly.options.nixpkgs?system;
    assert !readOnly.options.nixpkgs?localSystem;
    assert !readOnly.options.nixpkgs?crossSystem;

    pkgs.emptyFile;
}
