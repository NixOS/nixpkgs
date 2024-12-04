{ config, lib, ... }:

{
  options = {
    examples = lib.mkOption { type = lib.types.attrs; };
    assertion = lib.mkOption { type = lib.types.bool; };
  };

  config = {
    examples = with lib.gvariant; {
      bool = true;
      float = 3.14;
      int32 = mkInt32 (- 42);
      uint32 = mkUint32 42;
      int16 = mkInt16 (-42);
      uint16 = mkUint16 42;
      int64 = mkInt64 (-42);
      uint64 = mkUint64 42;
      array1 = [ "one" ];
      array2 = mkArray [ (mkInt32 1) ];
      array3 = mkArray [ (mkUint32 2) ];
      emptyArray = mkEmptyArray type.uint32;
      string = "foo";
      escapedString = ''
        '\
      '';
      tuple = mkTuple [ (mkInt32 1) [ "foo" ] ];
      maybe1 = mkNothing type.string;
      maybe2 = mkJust (mkUint32 4);
      variant = mkVariant "foo";
      dictionaryEntry = mkDictionaryEntry (mkInt32 1) [ "foo" ];
    };

    assertion =
      let
        mkLine = n: v: "${n} = ${toString (lib.gvariant.mkValue v)}";
        result = lib.concatStringsSep "\n" (lib.mapAttrsToList mkLine config.examples);
      in
      (result + "\n") == ''
        array1 = @as ['one']
        array2 = @ai [1]
        array3 = @au [@u 2]
        bool = true
        dictionaryEntry = @{ias} {1,@as ['foo']}
        emptyArray = @au []
        escapedString = '\'\\\n'
        float = 3.140000
        int16 = @n -42
        int32 = -42
        int64 = @x -42
        maybe1 = @ms nothing
        maybe2 = just @u 4
        string = 'foo'
        tuple = @(ias) (1,@as ['foo'])
        uint16 = @q 42
        uint32 = @u 42
        uint64 = @t 42
        variant = <'foo'>
      '';
  };
}
