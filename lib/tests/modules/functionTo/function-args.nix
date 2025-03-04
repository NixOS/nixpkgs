{ lib, config, ... }:
let
  inherit (lib) types;
in
{
  options = {
    uniqFun = lib.mkOption {
      type = types.uniq (types.functionTo types.str);
    };

    result = lib.mkOption {
      type = types.unspecified;
      default = lib.functionArgs config.uniqFun;
    };
  };

  config.uniqFun = {a, b}: "";
}
