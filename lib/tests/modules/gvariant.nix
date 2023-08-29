{ config, lib, ... }:

let inherit (lib) concatStringsSep mapAttrsToList mkMerge mkOption types gvariant;
in {
  options.examples = mkOption { type = types.attrsOf gvariant; };

  config = {
    examples = with gvariant;
      mkMerge [
        { bool = true; }
        { bool = true; }

        { float = 3.14; }

        { int32 = mkInt32 (- 42); }
        { int32 = mkInt32 (- 42); }

        { uint32 = mkUint32 42; }
        { uint32 = mkUint32 42; }

        { int16 = mkInt16 (-42); }
        { int16 = mkInt16 (-42); }

        { uint16 = mkUint16 42; }
        { uint16 = mkUint16 42; }

        { int64 = mkInt64 (-42); }
        { int64 = mkInt64 (-42); }

        { uint64 = mkUint64 42; }
        { uint64 = mkUint64 42; }

        { array1 = [ "one" ]; }
        { array1 = mkArray [ "two" ]; }
        { array2 = mkArray [ (mkInt32 1) ]; }
        { array2 = mkArray [ (nkUint32 2) ]; }

        { emptyArray1 = [ ]; }
        { emptyArray2 = mkEmptyArray type.uint32; }

        { string = "foo"; }
        { string = "foo"; }
        {
          escapedString = ''
            '\
          '';
        }

        { tuple = mkTuple [ (mkInt32 1) [ "foo" ] ]; }

        { maybe1 = mkNothing type.string; }
        { maybe2 = mkJust (mkUint32 4); }

        { variant1 = mkVariant "foo"; }
        { variant2 = mkVariant 42; }

        { dictionaryEntry = mkDictionaryEntry (mkInt32 1) [ "foo" ]; }
      ];

    assertions = [
      {
        assertion = (
          let
            mkLine = n: v: "${n} = ${toString (gvariant.mkValue v)}";
            result = concatStringsSep "\n" (mapAttrsToList mkLine config.examples);
          in
          result + "\n"
        ) == ''
          array1 = @as ['one','two']
          array2 = @au [1,2]
          bool = true
          dictionaryEntry = @{ias} {1,@as ['foo']}
          emptyArray1 = @as []
          emptyArray2 = @au []
          escapedString = '\'\\\n'
          float = 3.140000
          int = -42
          int16 = @n -42
          int64 = @x -42
          maybe1 = @ms nothing
          maybe2 = just @u 4
          string = 'foo'
          tuple = @(ias) (1,@as ['foo'])
          uint16 = @q 42
          uint32 = @u 42
          uint64 = @t 42
          variant1 = @v <'foo'>
          variant2 = @v <42>
        '';
      }
    ];
  };
}
