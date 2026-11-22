{ lib, options, ... }:
let
  fooOf =
    elemType:
    lib.mkOptionType {
      name = "foo";
      functor = {
        name = "foo";
        type = payload: fooOf payload.elemType;
        binOp = a: _b: a;
        payload.elemType = elemType;
      };
    };
in
{
  imports = [
    {
      options.foo = lib.mkOption {
        type = fooOf lib.types.int;
      };
    }
    {
      options.foo = lib.mkOption {
        type = fooOf lib.types.int;
      };
    }
  ];

  options.result = lib.mkOption {
    default = builtins.seq options.foo "ok";
  };
}
