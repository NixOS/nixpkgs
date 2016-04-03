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

  listenAddresses = config: interface:
    if interface == "lo"
    # lo isn't part of the enc. Hard code it here.
    then [ "127.0.0.1" "::1" ]
    else
      if builtins.hasAttr interface config.networking.interfaces
      then
        let
          interface_config = builtins.getAttr interface config.networking.interfaces;
        in
          (map (addr: addr.address) interface_config.ip4) ++
          (map (addr: addr.address) interface_config.ip6)
      else [];
}
