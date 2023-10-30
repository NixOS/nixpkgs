{lib}: let
  /*
  Converts an IP address from a list of ints to a string.

  Type: prettyIp :: [ Int ] -> String

  Examples:
    prettyIp [ 192 168 70 9 ]
    => "192.168.70.9"
  */
  prettyIp = addr:
    lib.concatStringsSep "." (builtins.map builtins.toString addr);

  /*
  Given a bit mask, return the associated subnet mask.

  Type: bitMaskToSubnetMask :: Int -> [ Int ]

  Examples:
    bitMaskToSubnetMask 15
    => [ 255 254 0 0 ]
    bitMaskToSubnetMask 24
    => [ 255 255 255 0 ]
  */
  bitMaskToSubnetMask = bitMask: let
    numOctets = 4;
    octetBits = 8;
    octetMin = 0;
    octetMax = 255;
    # How many initial parts of the mask are full (=255)
    fullParts = bitMask / octetBits;
  in
    lib.genList (
      idx:
      # Fill up initial full parts
        if idx < fullParts
        then octetMax
        # If we're above the first non-full part, fill with 0
        else if fullParts < idx
        then octetMin
        # First non-full part generation
        else _genPartialMask (lib.mod bitMask octetBits)
    )
    numOctets;

  /*
  Generate a the partial portion of a subnet mask.

  Type: _genPartialMask :: Int -> Int

  Examples:
    _genPartialMask 0
    => 0
    _genPartialMask 1
    => 128
    _genPartialMask 2
    => 192
    _genPartialMask 3
    => 224
    _genPartialMask 4
    => 240
    _genPartialMask 5
    => 248
    _genPartialMask 6
    => 252
    _genPartialMask 7
    => 254
  */
  _genPartialMask = n:
    if n == 0
    then 0
    else _genPartialMask (n - 1) / 2 + 128;

  /*
  Given a subnet mask, return the associated bit mask.

  Type: subnetMaskToBitMask :: [ Int ] -> Int

  Examples:
    subnetMaskToBitMask [ 255 254 0 0 ]
    => 15
    subnetMaskToBitMask [ 255 255 255 0 ]
    => 24
  */
  subnetMaskToBitMask = subnetMask: let
    partialBits = octet:
      if octet == 0
      then 0
      else (lib.mod octet 2) + partialBits (octet / 2);
  in
    builtins.foldl'
    (x: y: x + y)
    0
    (builtins.map partialBits subnetMask);

  /*
  Given a CIDR, return the IP Address.

  Type: cidrToIpAddress :: String -> [ Int ]

  Examples:
    cidrToIpAddress "192.168.70.9/15"
    => [ 192 168 70 9 ]
  */
  cidrToIpAddress = cidr: let
    splitParts = lib.splitString "/" cidr;
    addr = lib.elemAt splitParts 0;
    parsed =
      builtins.map
      lib.toInt
      (builtins.match "([0-9]+)\\.([0-9]+)\\.([0-9]+)\\.([0-9]+)" addr);
    checkBounds = octet:
      (octet >= 0) && (octet <= 255);
  in
    if (builtins.all checkBounds parsed)
    then parsed
    else builtins.throw "IP ${prettyIp addr} has out of bounds octet(s)";

  /*
  Given a CIDR, return the bitmask.

  Type: cidrToBitMask :: String -> Int

  Examples:
    cidrToBitMask "192.168.70.9/15"
    => 15
  */
  cidrToBitMask = cidr: let
    splitParts = lib.splitString "/" cidr;
    mask = lib.toInt (lib.elemAt splitParts 1);
    checkBounds = mask:
      (mask >= 0) && (mask <= 32);
  in
    if (checkBounds mask)
    then mask
    else builtins.throw "Bitmask ${builtins.toString mask} is invalid.";

  /*
  Given a CIDR, return the associated subnet mask.

  Type: cidrToSubnetMask :: String -> [ Int ]

  Examples:
    cidrToSubnetMask "192.168.70.9/15"
    => [ 255 254 0 0 ]
  */
  cidrToSubnetMask = cidr:
    bitMaskToSubnetMask (cidrToBitMask cidr);

  /*
  Given a CIDR, return the associated network ID.

  Type: cidrToNetworkId :: String -> [ Int ]

  Examples:
    cidrToNetworkId "192.168.70.9/15"
    => [ 192 168 0 0 ]
  */
  cidrToNetworkId = cidr: let
    ip = cidrToIpAddress cidr;
    subnetMask = cidrToSubnetMask cidr;
  in
    lib.zipListsWith lib.bitAnd ip subnetMask;

  /*
  Given a CIDR, return the associated first usable IP address.

  Type: cidrToFirstUsableIp :: String -> [ Int ]

  Examples:
    cidrToFirstUsableIp "192.168.70.9/15"
    => [ 192 168 0 1 ]
  */
  cidrToFirstUsableIp = cidr: let
    networkId = cidrToNetworkId cidr;
  in
    incrementIp networkId 1;

  /*
  Given a CIDR, return the associated broadcast address.

  Type: cidrToBroadcastAddress :: String -> [ Int ]

  Examples:
    cidrToBroadcastAddress "192.168.70.9/15"
    => [ 192 169 255 255 ]
  */
  cidrToBroadcastAddress = cidr: let
    subnetMask = cidrToSubnetMask cidr;
    networkId = cidrToNetworkId cidr;
  in
    getBroadcastAddress networkId subnetMask;

  /*
  Given a network ID and subnet mask, return the associated broadcast address.

  Type: getBroadcastAddress :: [ Int ] -> [ Int ] -> [ Int ]

  Examples:
    getBroadcastAddress [ 192 168 0 0 ] [ 255 254 0 0 ]
    => [ 192 169 255 255 ]
  */
  getBroadcastAddress = networkId: subnetMask:
    lib.zipListsWith (nid: mask: 255 - mask + nid) networkId subnetMask;

  /*
  Given a CIDR, return the associated last usable IP address.

  Type: cidrToLastUsableIp :: String -> [ Int ]

  Examples:
    cidrToLastUsableIp "192.168.70.9/15"
    => [ 192 169 255 254 ]
  */
  cidrToLastUsableIp = cidr: let
    broadcast = cidrToBroadcastAddress cidr;
  in
    incrementIp broadcast (-1);

  /*
  Increment the last octet of a given IP address.

  Type: incrementIp :: [ Int ] -> Int -> [ Int ]

  Examples:
    incrementIp [ 192 168 70 9 ] 3
    => [ 192 168 70 12 ]
    incrementIp [ 192 168 70 9 ] (-2)
    => [ 192 168 70 7 ]
  */
  incrementIp = addr: offset: let
    lastOctet = lib.last addr;
    firstThree = lib.init addr;
  in
    firstThree ++ [(lastOctet + offset)];

  /*
  Given an IP address and bit mask, return the associated CIDR.

  Type: ipAndBitMaskToCidr :: [ Int ] -> Int -> String

  Examples:
    ipAndBitMaskToCidr [ 192 168 70 9 ] 15
    => "192.168.70.9/15"
  */
  ipAndBitMaskToCidr = addr: bitMask:
    lib.concatStringsSep "/"
    [
      (prettyIp addr)
      (builtins.toString bitMask)
    ];

  /*
  Given an IP address and subnet mask, return the associated CIDR.

  Type: ipAndSubnetMaskToCidr :: [ Int ] -> Int -> String

  Examples:
    ipAndSubnetMaskToCidr [ 192 168 70 9 ] [ 255 254 0 0 ]
    => "192.168.70.9/15"
  */
  ipAndSubnetMaskToCidr = addr: subnetMask:
    ipAndBitMaskToCidr addr (subnetMaskToBitMask subnetMask);

  /*
  Given a CIDR, return an attribute set of:
    the IP Address,
    the bit mask,
    the first usable IP address,
    the last usable IP address,
    the network ID,
    the subnet mask,
    the broadcast address.

  Type: getNetworkProperties :: str -> attrset

  Examples:
    getNetworkProperties "192.168.70.9/15"
    => {
      bitMask = 15;
      broadcast = "192.169.255.255";
      firstUsableIp = "192.168.0.1";
      ipAddress = "192.168.70.9";
      lastUsableIp = "192.169.255.254";
      networkId = "192.168.0.0";
      subnetMask = "255.254.0.0";
    }
  */
  getNetworkProperties = cidr: let
    ipAddress = prettyIp (cidrToIpAddress cidr);
    bitMask = cidrToBitMask cidr;
    firstUsableIp = prettyIp (cidrToFirstUsableIp cidr);
    lastUsableIp = prettyIp (cidrToLastUsableIp cidr);
    networkId = prettyIp (cidrToNetworkId cidr);
    subnetMask = prettyIp (cidrToSubnetMask cidr);
    broadcast = prettyIp (cidrToBroadcastAddress cidr);
  in {inherit ipAddress bitMask firstUsableIp lastUsableIp networkId subnetMask broadcast;};
in {
  ipv4 = {
    inherit
      prettyIp
      incrementIp
      bitMaskToSubnetMask
      subnetMaskToBitMask
      ipAndBitMaskToCidr
      ipAndSubnetMaskToCidr
      cidrToIpAddress
      cidrToBitMask
      cidrToFirstUsableIp
      cidrToLastUsableIp
      cidrToNetworkId
      cidrToSubnetMask
      cidrToBroadcastAddress
      getNetworkProperties
      ;
  };
}
