{ config, lib, ... }:

{
  options = {
    loaOfInt = lib.mkOption {
      type = lib.types.loaOf lib.types.int;
    };

    result = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    loaOfInt = [ 1 2 3 4 5 6 7 8 9 10 ];

    result = toString (lib.attrValues config.loaOfInt);
  };
}
