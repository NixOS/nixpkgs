{ lib, ... }: {

  options.foo = lib.mkOption {
    default = {};
    type = lib.types.submodule {
      _module.checks.test = {
        enable = true;
        message = "Assertion failed";
      };
    };
  };

}
