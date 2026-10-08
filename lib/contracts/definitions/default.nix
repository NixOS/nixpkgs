# Contract types that nixpkgs defines.
# They are in `lib`, so that each module system can use them.
# Each file has the `meta` and the `interface` of one contract type.
# `lib.contract.definitionType` checks each contract type, and adds `mkContract`.
{ lib, ... }:
lib.mapAttrs
  (
    name: file:
    (lib.modules.mergeDefinitions [ "contracts" name ] lib.contract.definitionType [
      {
        file = toString file;
        value = import file { inherit lib; };
      }
    ]).mergedValue
  )
  {
    fileSecrets = ./file-secrets.nix;
  }
