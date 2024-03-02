{ lib, ... }:
let
  inherit (lib) mkOption types;

  moduleWithKey = {
    key = 123;
    config = {
      enable = true;
    };
  };
in
{
  options = {
    positive = mkOption {
      type = types.submodule {
        imports = [
          ./declare-enable.nix
          moduleWithKey
        ];
      };
      default = {};
    };
    negative = mkOption {
      type = types.submodule {
        imports = [
          ./declare-enable.nix
          moduleWithKey
        ];
        disabledModules = [ 123 ];
      };
      default = {};
    };
  };
}
