# the module can now request only what it needs without a `...`.
{ lib }: {
  options.foo = lib.mkOption { type = lib.types.str; };
  config.foo = "foo";
}
