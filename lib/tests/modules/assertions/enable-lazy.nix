{ lib, ... }: {

  options.foo = lib.mkOption {
    default = true;
  };

  options.bar = lib.mkOption {
    default = true;
  };

  config._module.checks.test = {
    enable = throw "enable evaluated";
    message = "Assertion failed";
    triggerPath = [ "foo" ];
  };

}
