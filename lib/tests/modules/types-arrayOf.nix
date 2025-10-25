{ lib, ... }:
{
  options = {
    simpleArray = lib.mkOption {
      type = lib.types.arrayOf lib.types.int 3;
      apply = v: builtins.deepSeq v v;
    };

    compositeArray = lib.mkOption {
      type = lib.types.arrayOf (lib.types.listOf lib.types.str) 2;
      apply = v: builtins.deepSeq v v;
    };

    wrongSize = lib.mkOption {
      type = lib.types.arrayOf lib.types.int 2;
      apply = v: builtins.deepSeq v v;
    };

    wrongType = lib.mkOption {
      type = lib.types.arrayOf lib.types.int 3;
      apply = v: builtins.deepSeq v v;
    };
  };

  config = {
    simpleArray = [
      1
      2
      3
    ];
    compositeArray = [
      [
        "a"
        "b"
      ]
      [
        "c"
        "d"
      ]
    ];
    wrongSize = [
      1
      2
      3
    ];
    wrongType = [
      1
      2
      "three"
    ];
  };
}
