{ lib, ... }: {
  imports = [
    {
      options.value = lib.mkOption {
        type = lib.types.orderOf {
          elemType = lib.types.submodule ({ name, ... }: {
            options.data = lib.mkOption {
              type = lib.types.str;
              default = name;
            };
          });
        };
      };
    }
    {
      options.value = lib.mkOption {
        type = lib.types.orderOf {
          before = a: b: a.value.before.${b.name} or false;
          elemType = lib.types.submodule {
            options.before = lib.mkOption {
              type = lib.types.attrsOf lib.types.bool;
              default = {};
            };
          };
        };
      };
    }
    {
      options.value = lib.mkOption {
        type = lib.types.orderOf {
          before = a: b: b.value.after.${a.name} or false;
          elemType = lib.types.submodule {
            options.after = lib.mkOption {
              type = lib.types.attrsOf lib.types.bool;
              default = {};
            };
          };
        };
      };
    }
  ];
}
