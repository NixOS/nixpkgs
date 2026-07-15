{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.bare-submodule = mkOption {
    type = types.submoduleWith {
      shorthandOnlyDefinesConfig = config.shorthandOnlyDefinesConfig;
      modules = [
        {
          options.nested = mkOption {
            type = types.int;
            default = 1;
          };
        }
      ];
    };
  };
}
