# `contracts-type-rename.nix` without a provider for the new name.
{ lib, ... }:
{
  contracts.count.defaultProvider = lib.mkForce null;
}
