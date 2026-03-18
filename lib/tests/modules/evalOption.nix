{ lib, ... }:
let
  inherit (lib) modules mkOption types;
in
{
  options.bar = mkOption {
    default =
      modules.evalOption
        (mkOption {
          default = { };
          type = types.submodule (
            { config, ... }:
            {
              options = {
                foo = mkOption {
                  type = types.int;
                };
                baz = mkOption {
                  default = config.foo + 1;
                };
              };
            }
          );
        })
        {
          foo = 1;
        };
  };
}
