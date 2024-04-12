{ lib }:
let
  inherit (lib)
    concatStringsSep
    elemAt
    genList
    mod
    range
    reverseList
    toInt
    ;

  inherit (builtins)
    all
    any
    foldl'
    toString
    ;
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
        foldl' (acc: _: acc * base) 1 (range 1 exponent);
  };

  ipv4 = {
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
      # ipv4 only has 4*8 = 32 bits, so 2^32 addresses
      else if num >= 4294967296 then
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
      else if (builtins.length splitCidr) > 2 then
        throw "lib.network.ipv4: Could not verify prefix length for CIDR ${cidr}."
      else
        let
          afterSlash = elemAt splitCidr 1;
        in
        if afterSlash == "" then
          throw "lib.network.ipv4: CIDR ${cidr} has no prefix length."
        else if toInt afterSlash > 32 || toInt afterSlash < 0 then
          throw "lib.network.ipv4: CIDR ${cidr} has an out of bounds prefix length, ${afterSlash}."
        else
          afterSlash;

    _verifyAddress =
      cidr:
      let
        splitCidr = lib.splitString "/" cidr;
        address = elemAt splitCidr 0;
        splitAddress = lib.splitString "." address;
        intOctets = map toInt splitAddress;
      in
      if (builtins.length splitAddress) != 4 then
        throw "lib.network.ipv4: CIDR ${cidr} is not of the correct form."
      else if any (x: x == "") splitAddress then
        throw "lib.network.ipv4: CIDR ${cidr} has an empty octet."
      else if !(all (x: x >= 0 && x <= 255)) intOctets then
        throw "lib.network.ipv4: CIDR ${cidr} has an out of bounds octet."
      else
        address;

    /**
      Given an IP address and prefix length, creates an attribute set of network parameters.

      # Example

      ```nix
      _parse "192.168.0.1/24"
      => {
        address = "192.168.0.1";
        cidr = "192.168.0.1/24";
        prefixLength = "24";
      }
      ```

      # Type

      ```
      _parse :: String -> IPv4Address
      ```

      # Arguments

      - [address] An IPv4 address.
      - [prefixLength] A prefix length.
    */
    _parse = address: prefixLength: {
      cidr = concatStringsSep "/" [
        address
        prefixLength
      ];
      inherit address prefixLength;
    };
  };
}
