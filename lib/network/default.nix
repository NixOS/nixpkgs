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

    /**
      Converts a 48-bit MAC address into a EUI-64 IPv6 address suffix.

      # Example

      ```nix
      mkEUI64Suffix "00:B0:D0:63:C2:26"
      => "2b0:d0ff:fe63:c226"
      ```

      # Type

      ```
      mkEUI64Suffix :: String -> String
      ```

      # Argumemts

      mac
      : The MAC address (may contain these delimiters: `:`, `-` or `.` but it's not necessary)
    */
    mkEUI64Suffix =
      mac:
      let
        sanitizedMac = builtins.replaceStrings [ ":" "-" "." ] [ "" "" "" ] mac;
        hextets = [
          (lib.toHexString (builtins.bitXor 512 (lib.fromHexString (builtins.substring 0 4 sanitizedMac))))
          ((builtins.substring 4 2 sanitizedMac) + "ff")
          ("fe" + (builtins.substring 6 2 sanitizedMac))
          (builtins.substring 8 4 sanitizedMac)
        ];
      in
      lib.toLower (builtins.concatStringsSep ":" hextets);
  };
}
