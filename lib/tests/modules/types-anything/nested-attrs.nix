{ lib, ... }:
{

  options.value = lib.mkOption {
    type = lib.types.anything;
  };

  config = lib.mkMerge [
    {
      value.foo = null;
    }
    {
      value.l1.foo = null;
    }
    {
      value.l1.l2.foo = null;
    }
    {
      value.l1.l2.l3.foo = null;
    }
  ];

}
