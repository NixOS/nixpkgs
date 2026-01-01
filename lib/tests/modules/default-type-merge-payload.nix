{ lib, options, ... }:
let
  foo =
    type:
    lib.mkOptionType {
      name = "foo";
      functor = {
        name = "foo";
        inherit type;
        binOp = a: _b: a;
        payload = 10;
      };
    };
in
{
  imports = [
    {
      options.foo = lib.mkOption {
        type = foo foo;
      };
    }
    {
      options.foo = lib.mkOption {
        type = foo foo;
      };
    }
  ];

  options.result = lib.mkOption {
    default = builtins.seq options.foo "ok";
  };
}
