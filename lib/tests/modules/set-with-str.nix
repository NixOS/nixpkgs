{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  imports = [
    {
      options.set = mkOption {
        type = types.setWith {
          elemType = types.str;
          toKey = str: str;
        };
      };
      options.result = mkOption { };
    }
  ];
}
