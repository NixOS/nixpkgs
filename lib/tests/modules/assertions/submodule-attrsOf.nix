{ lib, ... }: {

  options.foo = lib.mkOption {
    default = { bar = {}; };
    type = lib.types.attrsOf (lib.types.submodule {
      _module.checks.test = {
        check = false;
        message = "Assertion failed";
      };
    });
  };

}
