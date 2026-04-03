# Shared module: defines the `arithmetic` contract type for use in lib-level tests.
# Imports the generic contracts module directly (not the NixOS wrapper) so these
# tests work in the CI sandbox which only has lib/.
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  imports = [ lib.contract.module ];

  # Stub for the NixOS-level `meta` option expected by the contracts module.
  options.meta = mkOption {
    type = types.attrs;
    default = { };
  };

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
