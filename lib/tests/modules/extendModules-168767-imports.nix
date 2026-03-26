{
  lib,
  extendModules,
  ...
}:

let
  inherit (lib)
    mkOption
    mkOverride
    types
    ;
in
{
  imports = [

    {
      options.sub = mkOption {
        type = types.submodule (
          {
            config,
            extendModules,
            ...
          }:
          {
            options.value = mkOption {
              type = types.int;
            };

            options.specialisation = mkOption {
              inherit
                (extendModules {
                  modules = [
                    {
                      specialisation = mkOverride 0 { };
                    }
                  ];
                })
                type
                ;
            };
          }
        );
      };
    }

    { config.sub.value = 1; }

  ];
}
