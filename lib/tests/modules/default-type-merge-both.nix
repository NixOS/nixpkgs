{ lib, options, ... }:
let
  foo = lib.mkOptionType {
    name = "foo";
    functor = lib.types.defaultFunctor "foo" // {
      wrapped = lib.types.int;
      payload = 10;
    };
  };
in
{
  imports = [
    {
      options.foo = lib.mkOption {
        type = foo;
      };
    }
    {
      options.foo = lib.mkOption {
        type = foo;
      };
    }
  ];

  options.result = lib.mkOption {
    default = builtins.seq options.foo null;
  };
}
