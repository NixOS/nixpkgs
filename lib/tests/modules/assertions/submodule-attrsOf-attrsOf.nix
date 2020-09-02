{ lib, ... }: {

  options.foo = lib.mkOption {
    default = { bar.baz = {}; };
    type = lib.types.attrsOf (lib.types.attrsOf (lib.types.submodule {
      _module.assertions.test = {
        enable = true;
        message = "Assertion failed";
      };
    }));
  };

}
