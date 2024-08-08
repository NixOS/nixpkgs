{ lib, ... }:
{
  options.submodule = lib.mkOption {
    type = lib.types.submoduleWith {
      definedOptionsOnly = true;
      modules = [
        {
          options.defined = lib.mkOption { type = lib.types.bool; };
          options.hasDefault = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          options.undefined = lib.mkOption { type = lib.types.bool; };
        }
      ];
    };
  };

  config.submodule.defined = false;
}
