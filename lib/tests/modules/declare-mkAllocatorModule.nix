{ lib, config, ... }:

let
  commonArgs = {
    valueType = lib.types.port;
    valueKey = "port";
    firstValue = 49151;
    succFunc = x: x - 1;
    valueLiteral = toString;
    validateFunc = x: (lib.types.port.check x) && (x > 1024);
  };

  variations = [ "expected" "missing_value" "conflict" "invalid" ];
in

{
  options = lib.foldl' (old: next_variaton: old // {
    "${next_variaton}" = lib.mkAllocatorModule (commonArgs // {
      cfg = config."${next_variaton}";
      keyPath = "${next_variaton}";
    });
  }) {} variations;


  config = {
    expected = {
      example.enable = true;
      example.port = 42069;
    };
    missing_value = {
      example.enable = true;
    };
    conflict = {
      a.enable = true;
      a.port = 42069;
      b.enable = true;
      b.port = 42069;
    };
    invalid = {
      example.enable = true;
      example.port = 69;
    };
  };
}
