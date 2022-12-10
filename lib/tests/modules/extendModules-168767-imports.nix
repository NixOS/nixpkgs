{ lib
, extendModules
, ...
}:
with lib;
{
  imports = [

    {
      options.sub = mkOption {
        default = { };
        type = types.submodule (
          { config
          , extendModules
          , ...
          }:
          {
            options.value = mkOption {
              type = types.int;
            };

            options.specialisation = mkOption {
              default = { };
              inherit
                (extendModules {
                  modules = [{
                    specialisation = mkOverride 0 { };
                  }];
                })
                type;
            };
          }
        );
      };
    }

    { config.sub.value = 1; }


  ];
}
