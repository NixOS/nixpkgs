{ lib, ... }: {
  options.submodule = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [
        ({ lib, ... }: {
          options.foo = lib.mkOption {
            default = lib.foo;
          };
        })
      ];
      specialArgs.lib = lib // {
        foo = "foo";
      };
    };
    default = {};
  };
}
