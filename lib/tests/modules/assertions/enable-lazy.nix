{ lib, ... }: {

  options.foo = lib.mkOption {
    default = true;
  };

  options.bar = lib.mkOption {
    default = true;
  };

  config._module.assertions.test = {
    enable = throw "enable evaluated";
    message = "Assertion failed";
    triggerPath = [ "foo" ];
  };

}
