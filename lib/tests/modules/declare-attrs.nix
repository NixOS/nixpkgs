{ config, lib, ... }:

{
  options = {
    attrs = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
    };

    names = lib.mkOption {
      type = lib.types.str;
    };

    values = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    attrs = { alpha = 1; bravo = 2; charlie = 3; };
    names = toString (lib.attrNames config.attrs);
    values = toString (lib.attrValues config.attrs);
  };
}
