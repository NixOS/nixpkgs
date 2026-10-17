# A contract type with the name `warnings`, which `contracts.warnings` reserves.
{ lib, ... }:
let
  intOption = lib.mkOption { type = lib.types.int; };
in
{
  imports = [ lib.contract.module ];

  contractTypes.warnings = {
    meta = {
      description = "A number.";
      maintainers = [ lib.maintainers.kiara ];
    };
    interface.options = {
      request = intOption;
      response = intOption;
    };
  };
}
