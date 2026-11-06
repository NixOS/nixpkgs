{ lib, options, ... }:

{
  options.a.b = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };

  # Reading a nested option's declarations must not require the definitions
  # under its parent, e.g. to check them for unmatched definitions.
  config.a = if options.a.b.declarations != [ ] then { b.x = 1; } else { };
}
