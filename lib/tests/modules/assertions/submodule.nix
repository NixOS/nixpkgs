{ lib, ... }: {

  options.foo = lib.mkOption {
    default = {};
    type = lib.types.submodule {
      _module.checks.test = {
        check = false;
        message = "Assertion failed";
      };
    };
  };

}
