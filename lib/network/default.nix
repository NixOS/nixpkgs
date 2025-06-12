{ lib }:
let
  inherit (import ./internal.nix { inherit lib; }) _ipv6;
  inherit (lib.strings) match concatStringsSep toLower;
  inherit (lib.trivial)
    pipe
    bitXor
    fromHexString
    toHexString
    ;
  inherit (lib.lists) elemAt;
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
      mkEUI64Suffix "66:75:63:6B:20:75"
      => "6475:63ff:fe6b:2075"
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
      pipe mac [
        # match mac address
        (match "^([0-9A-Fa-f]{2})[-:.]?([0-9A-Fa-f]{2})[-:.]?([0-9A-Fa-f]{2})[-:.]?([0-9A-Fa-f]{2})[-:.]?([0-9A-Fa-f]{2})[-:.]?([0-9A-Fa-f]{2})$")

        # check if there are matches
        (matches: if matches == null then throw ''"${mac}" doesn't meet MAC address criteria'' else matches)

        # transform to result hextets
        (mac: [
          (toHexString (bitXor 512 (fromHexString ((elemAt mac 0) + (elemAt mac 1)))))
          "${elemAt mac 2}ff"
          "fe${elemAt mac 3}"
          ((elemAt mac 4) + (elemAt mac 5))
        ])

        # concat to result suffix
        (concatStringsSep ":")

        toLower
      ];
  };
}
