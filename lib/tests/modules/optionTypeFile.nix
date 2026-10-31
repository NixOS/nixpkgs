{ config, lib, ... }:
{

  _file = "optionTypeFile.nix";

  options.theType = lib.mkOption {
    type = lib.types.optionType;
  };

  options.theOption = lib.mkOption {
    type = config.theType;
    default = { };
  };

  config.theType = lib.mkMerge [
    (lib.types.submodule {
      options.nested = lib.mkOption {
        type = lib.types.int;
      };
    })
    (lib.types.submodule {
      _file = "other.nix";
      options.nested = lib.mkOption {
        type = lib.types.str;
      };
    })
  ];

}
