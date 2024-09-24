{
  lib ? import ../.,
}:
let
  inherit (builtins)
    map
    match
    genList
    length
    concatMap
    head
    toString
    ;

  inherit (lib) lists strings trivial;

  inherit (lib.lists) last;

  /*
    IPv6 addresses are 128-bit identifiers. The preferred form is 'x:x:x:x:x:x:x:x',
    where the 'x's are one to four hexadecimal digits of the eight 16-bit pieces of
    the address. See RFC 4291.
  */
  ipv6Bits = 128;
  ipv6Pieces = 8; # 'x:x:x:x:x:x:x:x'
  ipv6PieceBits = 16; # One piece in range from 0 to 0xffff.
  ipv6PieceMaxValue = 65535; # 2^16 - 1
in
let
  /**
    Expand an IPv6 address by removing the "::" compression and padding them
    with the necessary number of zeros. Converts an address from the string to
    the list of strings which then can be parsed using `_parseExpanded`.
    Throws an error when the address is malformed.

    # Type: String -> [ String ]

    # Example:

    ```nix
    expandIpv6 "2001:DB8::ffff"
    => ["2001" "DB8" "0" "0" "0" "0" "0" "ffff"]
    ```
  */
  expandIpv6 =
    addr:
    if match "^[0-9A-Fa-f:]+$" addr == null then
      throw "${addr} contains malformed characters for IPv6 address"
    else
      let
        pieces = strings.splitString ":" addr;
        piecesNoEmpty = lists.remove "" pieces;
        piecesNoEmptyLen = length piecesNoEmpty;
        zeros = genList (_: "0") (ipv6Pieces - piecesNoEmptyLen);
        hasPrefix = strings.hasPrefix "::" addr;
        hasSuffix = strings.hasSuffix "::" addr;
        hasInfix = strings.hasInfix "::" addr;
      in
      if addr == "::" then
        zeros
      else if
        let
          emptyCount = length pieces - piecesNoEmptyLen;
          emptyExpected =
            # splitString produces two empty pieces when "::" in the beginning
            # or in the end, and only one when in the middle of an address.
            if hasPrefix || hasSuffix then
              2
            else if hasInfix then
              1
            else
              0;
        in
        emptyCount != emptyExpected
        || (hasInfix && piecesNoEmptyLen >= ipv6Pieces) # "::" compresses at least one group of zeros.
        || (!hasInfix && piecesNoEmptyLen != ipv6Pieces)
      then
        throw "${addr} is not a valid IPv6 address"
      # Create a list of 8 elements, filling some of them with zeros depending
      # on where the "::" was found.
      else if hasPrefix then
        zeros ++ piecesNoEmpty
      else if hasSuffix then
        piecesNoEmpty ++ zeros
      else if hasInfix then
        concatMap (piece: if piece == "" then zeros else [ piece ]) pieces
      else
        pieces;

  /**
    Parses an expanded IPv6 address (see `expandIpv6`), converting each part
    from a string to an u16 integer. Returns an internal representation of IPv6
    address (list of integers) that can be easily processed by other helper
    functions.
    Throws an error some element is not an u16 integer.

    # Type: [ String ] -> IPv6

    # Example:

    ```nix
    parseExpandedIpv6 ["2001" "DB8" "0" "0" "0" "0" "0" "ffff"]
    => [8193 3512 0 0 0 0 0 65535]
    ```
  */
  parseExpandedIpv6 =
    addr:
    assert lib.assertMsg (
      length addr == ipv6Pieces
    ) "parseExpandedIpv6: expected list of integers with ${ipv6Pieces} elements";
    let
      u16FromHexStr =
        hex:
        let
          parsed = trivial.fromHexString hex;
        in
        if 0 <= parsed && parsed <= ipv6PieceMaxValue then
          parsed
        else
          throw "0x${hex} is not a valid u16 integer";
    in
    map (piece: u16FromHexStr piece) addr;
in
let
  /**
    Parses an IPv6 address from a string to the internal representation (list
    of integers).

    # Type: String -> IPv6

    # Example:

    ```nix
    parseIpv6FromString "2001:DB8::ffff"
    => [8193 3512 0 0 0 0 0 65535]
    ```
  */
  parseIpv6FromString = addr: parseExpandedIpv6 (expandIpv6 addr);
in
{
  /*
    Internally, an IPv6 address is stored as a list of 16-bit integers with 8
    elements. Wherever you see `IPv6` in internal functions docs, it means that
    it is a list of integers produced by one of the internal parsers, such as
    `parseIpv6FromString`
  */
  _ipv6 = {
    /**
      Converts an internal representation of an IPv6 address (i.e, a list
      of integers) to a string. The returned string is not a canonical
      representation as defined in RFC 5952, i.e zeros are not compressed.

      # Type: IPv6 -> String

      # Example:

      ```nix
      parseIpv6FromString [8193 3512 0 0 0 0 0 65535]
      => "2001:db8:0:0:0:0:0:ffff"
      ```
    */
    toStringFromExpandedIp =
      pieces: strings.concatMapStringsSep ":" (piece: strings.toLower (trivial.toHexString piece)) pieces;

    /**
      Extract an address and subnet prefix length from a string. The subnet
      prefix length is optional and defaults to 128. The resulting address and
      prefix length are validated and converted to an internal representation
      that can be used by other functions.

      # Type: String -> [ {address :: IPv6, prefixLength :: Int} ]

      # Example:

      ```nix
      split "2001:DB8::ffff/32"
      => {
        address = [8193 3512 0 0 0 0 0 65535];
        prefixLength = 32;
      }
      ```
    */
    split =
      addr:
      let
        splitted = strings.splitString "/" addr;
        splittedLength = length splitted;
      in
      if splittedLength == 1 then # [ ip ]
        {
          address = parseIpv6FromString addr;
          prefixLength = ipv6Bits;
        }
      else if splittedLength == 2 then # [ ip subnet ]
        {
          address = parseIpv6FromString (head splitted);
          prefixLength =
            let
              n = strings.toInt (last splitted);
            in
            if 1 <= n && n <= ipv6Bits then
              n
            else
              throw "${addr} IPv6 subnet should be in range [1;${toString ipv6Bits}], got ${toString n}";
        }
      else
        throw "${addr} is not a valid IPv6 address in CIDR notation";
  };
}
