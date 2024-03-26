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

    _encode =
      num:
      concatStringsSep "." (
        map (x: toString (mod (num / x) 256)) (reverseList (genList (x: common.pow 2 (x * 8)) 4))
      );

    _verifyPrefixLength =
      splitCidr:
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
