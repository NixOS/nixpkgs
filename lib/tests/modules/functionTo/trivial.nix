{ lib, config, ... }:
let
  inherit (lib) types;
in
{
  options = {
    fun = lib.mkOption {
      type = types.functionTo types.str;
    };

    result = lib.mkOption {
      type = types.str;
      default = config.fun "input";
    };
  };

  config.fun = input: "input is ${input}";
}
