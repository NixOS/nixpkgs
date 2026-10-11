{ lib, config, ... }:
{
  imports = [ lib.contract.module ];

  meta.doc = ./contracts.md;

  contractTypes = lib.contracts;

  inherit (config.contracts) warnings;
}
