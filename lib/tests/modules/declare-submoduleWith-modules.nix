{ lib, ... }:
{
  options.submodule = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [
        {
          options.inner = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        }
      ];
    };
    default = { };
  };

  config.submodule = lib.mkMerge [
    (
      { lib, ... }:
      {
        options.outer = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      }
    )
    {
      inner = true;
      outer = true;
    }
  ];
}
