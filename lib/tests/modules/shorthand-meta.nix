{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  imports = [
    ({ config, ... }: {
      options = {
        meta.foo = mkOption {
          type = types.listOf types.str;
        };
        result = mkOption { default = lib.concatStringsSep " " config.meta.foo; };
      };
    })
    {
      meta.foo = [ "one" "two" ];
    }
  ];
}
