{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) types;
in
{
  imports = [

    # fun.<function-body>.a
    (
      { ... }:
      {
        options = {
          fun = lib.mkOption {
            type = types.functionTo (
              types.submodule {
                options.a = lib.mkOption { default = "a"; };
              }
            );
          };
        };
      }
    )

    # fun.<function-body>.b
    (
      { ... }:
      {
        options = {
          fun = lib.mkOption {
            type = types.functionTo (
              types.submodule {
                options.b = lib.mkOption { default = "b"; };
              }
            );
          };
        };
      }
    )
  ];

  options = {
    result = lib.mkOption {
      type = types.str;
      default = lib.concatStringsSep " " (
        lib.attrValues (config.fun (throw "shouldn't use input param"))
      );
    };

    optionsResult = lib.mkOption {
      type = types.str;
      default = lib.concatStringsSep " " (
        lib.concatLists (
          lib.mapAttrsToList (k: v: if k == "_module" then [ ] else [ (lib.showOption v.loc) ]) (
            options.fun.type.getSubOptions [ "fun" ]
          )
        )
      );
    };
  };

  config.fun = lib.mkMerge [
    (input: { b = "bee"; })
  ];
}
