{ lib }:
let
  inherit (import ./internal.nix { inherit lib; }) _ipv6;
in
{
  ipv6 = {
    /**
      Creates an `IPv6Address` object from an IPv6 address as a string. If
      the prefix length is omitted, it defaults to 64. The parser is limited
      to the first two versions of IPv6 addresses addressed in RFC 4291.
      The form "x:x:x:x:x:x:d.d.d.d" is not yet implemented. Addresses are
      NOT compressed, so they are not always the same as the canonical text
      representation of IPv6 addresses defined in RFC 5952.

      # Type

      ```
      fromString :: String -> IPv6Address
      ```

      # Examples

      ```nix
      fromString "2001:DB8::ffff/32"
      => {
        address = "2001:db8:0:0:0:0:0:ffff";
        prefixLength = 32;
      }
      ```

      # Arguments

      - [addr] An IPv6 address with optional prefix length.
    */
    fromString =
      addr:
      let
        splittedAddr = _ipv6.split addr;

        addrInternal = splittedAddr.address;
        prefixLength = splittedAddr.prefixLength;

        address = _ipv6.toStringFromExpandedIp addrInternal;
      in
      {
        inherit address prefixLength;
      };
  };
}
