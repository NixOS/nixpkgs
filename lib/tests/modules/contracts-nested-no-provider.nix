{ lib, ... }:
{
  contracts.sum.defaultProvider = lib.mkForce null;
}
