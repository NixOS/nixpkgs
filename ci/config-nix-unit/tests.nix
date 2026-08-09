# Tests for `nixpkgs.config` that cannot run at evaluation time, either
# because they match the text of an error, which `builtins.tryEval` never
# exposes, or because they depend on the process environment.
#
# Everything that can be asserted on a value lives in `pkgs/test/config.nix`,
# where it runs at evaluation time and costs no build.
#
# Run with:
#   nix-build ci -A config-nix-unit
#
# Running `nix-unit` on this file directly requires `$NIXPKGS_CONFIG` to point
# at a file containing `{ allowUnfree = true; }`, which `./default.nix` sets up.
#
{
  nixpkgsPath ? ../..,
  pkgs ? import nixpkgsPath { },
}:
let
  lib = pkgs.lib;

  located = file: modules: map (lib.modules.setDefaultModuleLocation file) modules;
in
{
  # Nixpkgs reports the file a conflicting `config` definition came from.
  testConfigModuleLocations = {
    expr =
      (import nixpkgsPath {
        config = located "some-file.nix" [
          { fetchedSourceNameDefault = "versioned"; }
          { fetchedSourceNameDefault = "full"; }
        ];
      }).config.fetchedSourceNameDefault;
    expectedError = {
      type = "ThrownError";
      msg = ".*some-file.nix.*";
    };
  };

  # The NixOS module forwards definitions unevaluated, so a conflict points at
  # the NixOS module that defined it rather than at Nixpkgs internals.
  testNixosConfigConflictLocation = {
    expr =
      (import (nixpkgsPath + "/nixos/lib/eval-config.nix") {
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
        ]
        ++ located "my-nixos-module.nix" [
          { nixpkgs.config.fetchedSourceNameDefault = "versioned"; }
          { nixpkgs.config.fetchedSourceNameDefault = "full"; }
        ];
      }).pkgs.config.fetchedSourceNameDefault;
    expectedError = {
      type = "ThrownError";
      msg = ".*my-nixos-module.nix.*";
    };
  };

  # Control for the test below: importing Nixpkgs without a `config` argument
  # does read `$NIXPKGS_CONFIG`. Without this, a NixOS package set could look
  # unaffected by the environment merely because the variable was never seen.
  testEnvironmentConfigIsRead = {
    expr = (import nixpkgsPath { }).config.allowUnfree;
    expected = true;
  };

  # The NixOS module always passes `config`, so `$NIXPKGS_CONFIG` must not
  # reach a package set it built. This is what the module's former explicit
  # `config = { }` protected, before the definitions were passed as modules.
  testNixosConfigIgnoresEnvironment = {
    expr =
      (import (nixpkgsPath + "/nixos/lib/eval-config.nix") {
        modules = [ { nixpkgs.hostPlatform = "x86_64-linux"; } ];
      }).pkgs.config.allowUnfree;
    expected = false;
  };
}
