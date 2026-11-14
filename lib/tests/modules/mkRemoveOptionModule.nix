{ lib, config, ... }:
{
  imports = [
    ./assertions.nix
    (lib.mkRemovedOptionModule [ "a" "b" ] "instructions")
    (lib.mkRemovedOptionModule [ "c" "d" "e" ] "")
  ];

  options = {
    errors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = map (x: x.message) (lib.filter (x: !x.assertion) config.assertions);
    };
    submodules = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule [
          ./assertions.nix
          (lib.mkRemovedOptionModule [ "sub" "opt" ] "suboption")
        ]
      );
    };
  };

  config = {
    a.b = lib.mkDefinition {
      file = "example-file";
      value = 1234;
    };

    submodules = lib.mkDefinition {
      file = "another-file";
      value = {
        x = {
          # empty
        };
        y.sub.opt = "err1";
        z.sub.opt = "err2";
      };
    };

    # Propagate submodule assertions
    assertions = lib.concatMap (x: x.assertions) (lib.attrValues config.submodules);
  };
}
