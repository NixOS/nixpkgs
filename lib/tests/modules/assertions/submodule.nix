{ lib, ... }: {

  options.foo = lib.mkOption {
    default = {};
    type = lib.types.submodule {
      _module.assertions.test = {
        enable = true;
        message = "Assertion failed";
      };
    };
  };

}
