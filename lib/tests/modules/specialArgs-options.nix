{ lib, ... }:
{
  config = {
    _module.freeformType = lib.types.anything;

    fail = lib.evalModules {
      specialArgs = {
        options = { };
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
