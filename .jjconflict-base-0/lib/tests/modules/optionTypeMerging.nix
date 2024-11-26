{ config, lib, ... }:
{

  options.theType = lib.mkOption {
    type = lib.types.optionType;
  };

  options.theOption = lib.mkOption {
    type = config.theType;
  };

  config.theType = lib.mkMerge [
    (lib.types.submodule {
      options.int = lib.mkOption {
        type = lib.types.int;
        default = 10;
      };
    })
    (lib.types.submodule {
      options.str = lib.mkOption {
        type = lib.types.str;
      };
    })
  ];

  config.theOption.str = "hello";

}
