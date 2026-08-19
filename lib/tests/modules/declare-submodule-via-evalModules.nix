{ lib, ... }:
{
  options.submodule = lib.mkOption {
    inherit
      (lib.evalModules {
        modules = [
          {
            options.inner = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
          }
        ];
      })
      type
      ;
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
