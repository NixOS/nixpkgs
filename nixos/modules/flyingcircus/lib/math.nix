/*
 * generic arithmetic functions not included in Nix core
 */

{ lib }:

rec {
  # funny that the modulo function seems not to be defined anywhere
  mod = x : n : x - (builtins.div x n) * n;

  # convert value [0..15] into a single hex digit
  hexDigit = x : builtins.elemAt (lib.stringToCharacters "0123456789abcdef") x;

  # convert value [0..255] into two hex digits
  byteToHex = x : lib.concatStrings [
    (hexDigit (builtins.div x 16)) (hexDigit (mod x 16))
  ];
}
