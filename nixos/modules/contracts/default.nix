{ lib, ... }:
{
  imports = [ lib.contract.module ];

  meta.doc = ./contracts.md;

  contractTypes = lib.contracts;
}
