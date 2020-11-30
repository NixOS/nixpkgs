{ lib, config, ... }: {

  options.foo = lib.mkOption {
    default = true;
  };

  options.bar = lib.mkOption {
    default = config.foo;
  };

  config._module.checks.foo = {
    enable = true;
    message = "Foo assertion";
    triggerPath = [ "foo" ];
  };

}
