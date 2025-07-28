{ lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  options = {
    osType = mkOption {
      type = types.optionType;
      defaultText = lib.literalMD ''
        NixOS as an option type
        '';
    };
    moduleForName = mkOption {
      type = types.functionTo types.deferredModule;
      default = { };
      description = ''
        A function that receives the machine name and returns a module that may use the machine name.
        This is added to all nodes.
      '';
    };
  };
}