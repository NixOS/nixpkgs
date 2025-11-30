# Generates a lookup table mapping bytes (as single-byte strings) to their
# hexadecimal representation (as two-character uppercase strings).
#
# This is used by lib.strings.escapePythonBytes to convert arbitrary byte
# sequences into Python bytes literals.

let
  # Hex digits
  hexDigits = [
    "0"
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
    "A"
    "B"
    "C"
    "D"
    "E"
    "F"
  ];

  # Generate a two-digit hex string from a number (0-255).
  toHex =
    n:
    let
      high = n / 16;
      low = n - (high * 16);
    in
    builtins.elemAt hexDigits high + builtins.elemAt hexDigits low;

  # Create a string containing all bytes from 0x01 to 0xFF.
  # We do this by reading a pre-generated binary file that contains all these bytes.
  # This is necessary because Nix doesn't provide a way to construct arbitrary
  # byte values programmatically - we can only work with strings that come from
  # external sources (files, environment variables, etc.).
  allBytesFile = ./all-bytes-except-null.bin;
  allBytes = builtins.readFile allBytesFile;

  # Split the string into individual bytes.
  byteList = builtins.genList (i: builtins.substring i 1 allBytes) (builtins.stringLength allBytes);

  # Create attribute set mapping each byte to its hex representation.
  # We know the file contains bytes 0x01 through 0xFF in order.
  byteAttrs = builtins.genList (i: {
    name = builtins.elemAt byteList i;
    value = toHex (i + 1);
  }) 255;

in
builtins.listToAttrs byteAttrs
