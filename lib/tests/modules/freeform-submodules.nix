{ lib, options, ... }:
with lib.types;
{

  options.fooDeclarations = lib.mkOption {
    default = (options.free.type.getSubOptions [ ])._freeformOptions.foo.declarations;
  };

  options.free = lib.mkOption {
    type = submodule {
      config._module.freeformType = lib.mkMerge [
        (attrsOf (submodule {
          options.foo = lib.mkOption { };
        }))
        (attrsOf (submodule {
          options.bar = lib.mkOption { };
        }))
      ];
    };
  };

  config.free.xxx.foo = 10;
  config.free.yyy.bar = 10;
}
