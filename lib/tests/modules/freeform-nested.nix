{ lib, ... }: {
  options.nest.foo = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };
  config.nest.bar = "bar";
}
