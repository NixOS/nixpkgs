{ lib, config, ... }:
{
  imports = [ lib.contract.module ];

  meta.doc = ./contracts.md;

  # `mkContract` and `mkProviderType` are read-only, so set only the options that a definition sets.
  contractTypes = lib.mapAttrs (_: contractType: {
    inherit (contractType) meta interface;
  }) lib.contracts;

  inherit (config.contracts) warnings;
}
