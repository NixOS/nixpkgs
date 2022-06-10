{ config, extendModules, lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (types) attrsOf submodule;
in
{
  options = {
    withKey = mkOption {
      type = attrsOf (
        submodule ({ name, ... }: {
          options.value = mkOption {
            type = attrsOf (
              (extendModules {
                attrArgName = name;
              }).type
            );
          };
        })
      );
    };
    res = mkOption {
      type = types.str;
    };
    result = mkOption {
      default = config.withKey.foo.value.qux.withKey.bar.value.xyz.res;
    };
  };
  config = {
    withKey.foo.value.qux.withKey.bar.value.xyz = { foo, bar, lib, config, ... }: {
      res = "foo=" + foo + ",bar=" + bar;
    };
  };
}
