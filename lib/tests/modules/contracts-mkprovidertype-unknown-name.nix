{ lib, ... }:
{
  contracts.connection.defaultProviderName = lib.mkForce "missing";
}
