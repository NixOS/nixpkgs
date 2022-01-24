{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.bare-submodule = mkOption {
    type = types.submoduleWith {
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
