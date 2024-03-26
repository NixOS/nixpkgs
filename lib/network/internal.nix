{lib}: {
  ipv4 = rec {
    _prefixToSubnetMask = prefix: let
      prefix' = lib.toInt prefix;
      numOctets = 4;
      octetBits = 8;
      octetMin = 0;
      octetMax = 255;
      # How many initial parts of the mask are full (=255)
      fullParts = prefix' / octetBits;
    in
      lib.concatMapStringsSep
      "."
      builtins.toString
      (
        lib.genList (
          idx:
          # Fill up initial full parts
            if idx < fullParts
            then octetMax
            # If we're above the first non-full part, fill with 0
            else if fullParts < idx
            then octetMin
            # First non-full part generation
            else _genPartialMask (lib.mod prefix' octetBits)
        )
        numOctets
      );

    _genPartialMask = n:
      if n == 0
      then 0
      else _genPartialMask (n - 1) / 2 + 128;

    _verifyPrefixLength = splitCidr:
      if (builtins.length splitCidr) == 1
      then "32"
      else if (builtins.length splitCidr) == 2
      then
        if lib.elemAt splitCidr 1 == ""
        then throw "no empty prefix"
        else lib.elemAt splitCidr 1
      else throw "bad stuff happened";

    _makeIPv4 = address: prefixLength: {
      cidr = lib.concatStringsSep "/" [address prefixLength];
      inherit address prefixLength;
      subnetMask = _prefixToSubnetMask prefixLength;
    };
  };
}
