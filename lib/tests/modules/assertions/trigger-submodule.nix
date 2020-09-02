{ lib, ... }: {

  options.foo = lib.mkOption {
    default = { bar = {}; };
    type = lib.types.attrsOf (lib.types.submodule {
      options.baz = lib.mkOption {
        default = true;
      };
    });
  };

  config._module.assertions.test = {
    enable = true;
    message = "Assertion failed";
    triggerPath = [ "foo" "bar" "baz" ];
  };

}
