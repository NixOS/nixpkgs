{ lib }:
let
  inherit (lib)
    concatStringsSep
    elemAt
    fold
    foldl
    genList
    mod
    range
    reverseList
    toInt
    ;

  inherit (builtins) toString;
in
rec {
  common = {
    /**
      Given a base and exponent, calculates base raised to the exponent.

      # Example

      ```nix
      pow 2 3
      => 8
      ```

      # Type

      ```
      pow :: Int -> Int -> Int
      ```

      # Arguments

      - [base] The base.
      - [exponent] The exponent.

      # Throws

      - If the exponent is less than 0.
    */
    pow =
      base: exponent:
      if exponent < 0 then
        throw "lib.network.pow: Exponent cannot be negative."
      else if exponent == 0 then
        1
      else
        fold (x: y: y * base) base (range 2 exponent);
  };

  ipv4 = rec {
    _prefixToSubnetMask =
      prefixLength:
      let
        prefixLength' = toInt prefixLength;
      in
      _encode ((foldl (x: y: 2 * x + 1) 0 (range 1 prefixLength')) * (common.pow 2 (32 - prefixLength')));

    /**
      Encodes an integer into a valid IPv4 address.

      # Example

      ```nix
      _encode 0
      => "0.0.0.0"
      _encode 3232235521
      => "192.168.0.1"
      ```

      # Type

      ```
      _encode :: Int -> String
      ```

      # Arguments

      - [num] A decoded integer representation of an IPv4 address.

      # Throws

      - If the argument is less than zero.
      - If the argument is greater than or equal to 2^32.
    */
    _encode =
      num:
      if num < 0 then
        throw "lib.network.ipv4._encode: ${toString num} cannot be encoded into an IPv4 address."
      else if num > 4294967295 then
        throw "lib.network.ipv4._encode: ${toString num} is too large to encode into an IPv4 address."
      else
        concatStringsSep "." (
          map (x: toString (mod (num / x) 256)) (reverseList (genList (x: common.pow 2 (x * 8)) 4))
        );

    /**
      Extracts a prefix length from a CIDR and verifies it is valid.

      If an IP address is given without a CIDR, then a prefix length of 32 is returned.

      # Example

      ```nix
      _verifyPrefixLength "192.168.0.1/24"
      => 24
      _verifyPrefixLength "192.168.0.1"
      => 32
      ```

      # Type

      ```
      _verifyPrefixLength :: String => String
      ```

      # Arguments

      - [cidr] An IPv4 CIDR.

      # Throws

      - If a CIDR was given with a slash but no prefix length following.
      - If there were multiple slashes in the CIDR.
    */
    _verifyPrefixLength =
      cidr:
      let
        splitCidr = lib.splitString "/" cidr;
      in
      if (builtins.length splitCidr) == 1 then
        "32"
      else if (builtins.length splitCidr) == 2 then
        if elemAt splitCidr 1 == "" then
          throw "lib.network: Got a CIDR with no prefix length."
        else
          elemAt splitCidr 1
      else
        throw "lib.network: Could not verify prefix length.";

    _makeIPv4 = address: prefixLength: {
      cidr = concatStringsSep "/" [
        address
        prefixLength
      ];
      inherit address prefixLength;
      subnetMask = _prefixToSubnetMask prefixLength;
    };
  };
}
