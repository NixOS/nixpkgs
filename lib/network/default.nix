{ lib }:
let
  inherit (import ./internal.nix { inherit lib; }) _ipv6;
in
{
  ipv6 = {
    /**
      Creates an `ipv6AddrAttrs` object from an `ipv6Addr` (valid ip string). If
      the prefix length is omitted, it defaults to *128*.

      The parser is limited to the first two versions of IPv6 addresses
      addressed in RFC 4291. An alternative form that is sometimes
      more convenient when dealing with a mixed environment of IPv4
      "x:x:x:x:x:x:d.d.d.d" is not yet implemented.

      Addresses are NOT compressed, so they are not always the same as the
      canonical text representation of IPv6 addresses defined in RFC 5952.

      The fields of the returned set may contain errors if an invalid ip string
      was passed. So, to make sure the parsing completes successfully, you need to
      deeply evaluate all fields using `builtins.deepSeq`.

      # Type

      ```
      fromString :: ipv6Addr -> ipv6AddrAttrs
      ```

      # Examples

      ```nix
      fromString "2001:DB8::ffff/64"
      => {
        address = "2001:db8:0:0:0:0:0:ffff";
        addressCidr = "2001:db8:0:0:0:0:0:ffff/64";
        url = "[2001:db8:0:0:0:0:0:ffff]";
        urlWithPort = int -> string;
        prefixLength = 64;
      }
      (fromString "2001:DB8::ffff/64").urlWithPort 80
      => "[2001:db8:0:0:0:0:0:ffff]:80";
      ```

      # Arguments

      addrStr
      : A string version of IPv6 address with optional prefix length.
    */
    fromString =
      addrStr:
      let
        splittedAddr = _ipv6.split addrStr;
      in
      _ipv6.makeIpv6Type splittedAddr.address splittedAddr.prefixLength;

    /**
      Checks whether a string is a valid IPv6 address, which can then be
      safely parsed by other library functions such as `fromString`.

      This is accomplished by calling `fromString` and deeply evaluating the
      returned set of attributes to ensure that no field contains an error.

      Used as a type checker for `ipv6Addr`. You probably don't want to call
      it directly.

      # Type

      ```
      isValidIpStr :: string -> bool
      ```

      # Examples

      ```nix
      isValidIpStr "2001:DB8::ffff/64"
      => true
      isValidIpStr "::/"
      => false
      ```

      # Arguments

      addrStr
      : A string version of IPv6 address with optional prefix length.
    */
    isValidIpStr =
      addrStr:
      let
        parsed = lib.network.ipv6.fromString addrStr;
        # Several fields may contain error(_address, prefixLength), so we need
        # to deeply evaluate the returned set to make sure the address is valid.
        isValid = (builtins.tryEval (builtins.deepSeq parsed parsed)).success;
      in
      isValid;
  };
}
