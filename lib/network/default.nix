{ lib }:
let
  internal = import ./internal.nix { inherit lib; };
in
{
  ipv4 = {
    fromCidrString =
      cidr:
      let
        splitCidr = lib.splitString "/" cidr;
        address = lib.elemAt splitCidr 0;
        prefixLength = internal.ipv4._verifyPrefixLength cidr;
      in
      internal.ipv4._makeIPv4 address prefixLength;
  };
}
