{ lib }:
let
  internal = import ./internal.nix { inherit lib; };
in
{
  ipv4 = {
    fromCidrString =
      cidr:
      let
        address = internal.ipv4._verifyAddress cidr;
        prefixLength = internal.ipv4._verifyPrefixLength cidr;
      in
      internal.ipv4._parse address prefixLength;
  };
}
