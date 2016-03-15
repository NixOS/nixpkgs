/*
 * generic networking functions for use in all of the flyingcircus Nix stuff
 */

{ lib }:

{
  stripNetmask = cidr: builtins.elemAt (lib.splitString "/" cidr) 0;

  prefixLength = cidr:
    lib.toInt (builtins.elemAt (lib.splitString "/" cidr) 1);

  isIp4 = address_or_network:
    builtins.length (lib.splitString "." address_or_network) == 4;

  isIp6 = address_or_network:
    builtins.length (lib.splitString ":" address_or_network) > 1;
}
