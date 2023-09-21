{ lib, ... }:
let
  inherit (lib) mkOption types;

  moduleWithKey = {
    key = "disable-module-with-key.nix#moduleWithKey";
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
        disabledModules = [ moduleWithKey ];
      };
      default = {};
    };
  };
}
