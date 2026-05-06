# Defines the `arithmetic` contract type for use in contract tests.
# This module can be imported in both NixOS tests and bare lib.evalModules tests
# (the latter must also import `nixos/modules/contracts/default.nix` separately).
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  config.contractTypes.arithmetic = {
    meta = {
      description = "A contract for arithmetic operations, used for testing.";
      maintainers = [ ];
    };
    interface = {
      request.value = mkOption {
        description = "Input value.";
        type = types.int;
      };
      result.value = mkOption {
        description = "Output value.";
        type = types.int;
      };
    };
  };
}
