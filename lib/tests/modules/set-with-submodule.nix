{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  imports = [
    {
      options.set = mkOption {
        # Because tests dont pass --strict
        apply = v: lib.deepSeq v v;
        type = types.setWith {
          elemType = types.submodule (
            { config, ... }:
            {
              options.key = mkOption {
                type = types.str;
                # Default for the key depends on both 'foo' and ''bar'
                default = config.foo + config.bar;
              };
              options.foo = mkOption { };
              options.bar = mkOption { };
            }
          );
          toKey = m: m.key;
        };
      };
      options.result = mkOption { };
    }
  ];
}
