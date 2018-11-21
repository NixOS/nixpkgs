{ lib }:
let
  inherit (lib) concatStrings concatMapStringsSep mod splitString;
  inherit (builtins) genList head isString replaceStrings stringLength
  substring;

  _lib = rec {

    # Convert a number base 10 to another number base k (k <= 16)
    # l determins the 0 prefixed length of the output.
    # Returns the output as a string
    klconv = k: l: num:
      let
        snum = { base = k; d = num; c = 0; result = ""; };
        replaceDigit = d: replaceStrings [ "10" "11" "12" "13" "14" "15" ]
          [  "a"  "b"  "c"  "d"  "e"  "f" ] d;
        kconvDigit = { d, ... }@args:
          args // { d = args.d / args.base;
                    result = replaceDigit (toString (d - ((d / args.base) * args.base))) + args.result;
                  };
        kconv' = snum:
          if snum.d == 0
          then if stringLength snum.result < l
               then (concatStrings (genList (_: "0") (l - stringLength snum.result))) + snum.result
               else snum.result
          else kconv' (kconvDigit snum);
      in kconv' snum;

    # Convert integer to octal code string of 16 or 8 bits
    octconv16 = x: let
      low = mod x 256;
      high = (mod x 65536) / 256;
    in "\\" + (substring 0 3 (klconv 8 3 high)) + "\\" + (substring 0 3 (klconv 8 3 low));
    octconv8 = x: let s =(klconv 8 3 x); in "\\" + (substring 0 3 s);

    # Convert seconds since Epoch to TAI64 into hex-coded string external format
    epochToTAI64 = epoch: klconv 16 0 (4611686018427387904 + epoch);

    # Quote special characters with octal replacements to suit tinydns-data
    quoteDATA = s: replaceStrings
      [ " "     "#"     ":"     ]
      [ "\\040" "\\043" "\\072" ] s;

    # Convert string into fixed-length string
    # abcd -> \004abcd
    fixedString = s: let
      prefixShort = short: (octconv8 (stringLength short)) + (quoteDATA short);
      fixedString' = s:
        if stringLength s > 255
        then (prefixShort (substring 0 255 s))+ (fixedString' (substring 255 (stringLength s) s))
        else prefixShort s;
    in
      if stringLength s <= 65280 then fixedString' s
      else abort "String payload too big, must be less than 65281 bytes";

    # Split target at '.' into a length-prefixed string list suitable for tinydns-data
    # abcd.ef. -> \004abcd\002ef\000
    splitTarget = target:
      concatStrings (map fixedString (splitString "." target));

    # Make a DNS record by taking a prefabricated record and parsing the
    # additional flags ttl, timestamp and location
    dataFlags = { ttl ? "", ts ? "", location ? "", ... }:
      ":${if ttl == null then "" else if isString ttl then ttl else toString ttl}"
      + ":${if ts == null then "" else if isString ts then ts else epochToTAI64 ts}"
      + ":" + location;

    # Verbatim record. Take data as is.
    DATA = { data, ...}@args: data;

    # Make an AFSDB DNS record
    AFSDB = { cell, server, ... }@args:
      ":${cell}:18:" + (octconv16 1) + (splitTarget server) + (dataFlags args);

    # Make a SRV DNS record
    SRV = { service, priority, weight, port, target, ... }@args:
      ":${service}:33:" + (concatStrings (map octconv16 [ priority weight port ])) + (splitTarget target) + dataFlags args;

    # Make a TXT DNS record
    TXT = { service, txt, ... }@args:
      ":${service}:16:" + (fixedString txt) + (dataFlags args);

    # Make a URI DNS record
    URI = { service, priority, weight, payload, ... }@args:
      ":${service}:256:" + "${octconv16 priority}${octconv16 weight}" + (quoteDATA payload) + (dataFlags args);
  }; # _lib

# Update the documentation of services.tinydns.*.data when adding new record-building functions, here!
in {
  toTxt = concatMapStringsSep "\n" (record: _lib.${record.type} record);
}
