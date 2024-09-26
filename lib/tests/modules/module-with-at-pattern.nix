# this no longer works since functionArgs is blind to both `...` and `@`-patterns
{ ... }@inputs: {
  options.foo = inputs.lib.mkOption { type = inputs.lib.types.str; };
  config.foo = "foo";
}
