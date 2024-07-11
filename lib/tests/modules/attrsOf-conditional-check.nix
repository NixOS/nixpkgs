{ lib, config, ... }: {
  options.conditionalWorks = lib.mkOption {
    default = ! config.value ? foo;
  };

  config.value.foo = lib.mkIf false "should not be defined";
}
