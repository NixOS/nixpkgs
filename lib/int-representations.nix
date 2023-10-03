/* Collection of functions for bit representation conversions such as binary,
   octal, decimal and hexadecimal.

   These functions works by using a bit mapping, a attrset that maps each
   character to a numerical value. The base of the numeric system is the length
   of the keys of this attrset.
*/

{ lib }:

{
  /* Default bit mappings for the most common bases */
  mappings = { # maps characters to values
    bin = [ "0" "1"];
    oct = [ "0" "1" "2" "3" "4" "5" "6" "7" ];
    dec = [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
    hex = [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" ];
  };

  /* Convert an integer to the string representation following the mapping.

     Type: toStringRepresentation :: attrs -> int -> string

     Example:
      toStringRepresentation bitMappings.hex 255
      => "FF"
  */
  toStringRepresentation =
    # List of symbols of the base alphabet. Base number is inferred from the size.
    mapping:
    # Integer to be converted
    number:
  let
    mappingBase = lib.length mapping;
    digits = lib.toBaseDigits mappingBase number;

    chars = map (digit: lib.elemAt mapping digit) digits;

  in lib.concatStringsSep "" chars;

  /* Convert a string representation to integer using the mapping.

     Note that this function doesn't support prefixes such as 0x for
     hexadecimal.

     Type: fromStringRepresentation :: attrs -> string -> int

     Example:
      fromStringRepresentation bitMappings.hex "ff"
      => 255
  */
  fromStringRepresentation =
    # List of symbols of the base alphabet. Base number is inferred from the size.
    mapping:
    # String representation to be converted
    repr:
  let
    throwInvalidChar = throw "invalid symbol in '${repr}', all valid symbols in this mapping: ${lib.concatStringsSep ", " mapping}";

    lookupTable = lib.mkLookupTable mapping;

    # which base?
    mappingMultiplier = lib.length mapping;

    chars = lib.splitString "" repr;
    nonEmptyChars = (lib.filter (c: c != "")) chars;

    getCharValue = c: lookupTable.${c} or throwInvalidChar;

    charValues = map getCharValue nonEmptyChars;
    reversedChars = lib.reverseList charValues;

    convertChars = charList:
      if lib.length charList == 0
      then 0
      else (mappingMultiplier * (convertChars (lib.tail charList))) + (lib.head charList);
  in convertChars reversedChars;
}
