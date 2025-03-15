{ lib, ... }:
{
  config = {
    _module.freeformType = lib.types.anything;

    fail = lib.evalModules {
      specialArgs = {
        config = { };
      };
      modules = [
        {
          options.a = lib.mkEnableOption "a";
          config.a = true;
        }
      ];
    };
  };
}
