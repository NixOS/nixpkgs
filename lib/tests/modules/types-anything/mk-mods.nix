{ lib, ... }: {

  options.value = lib.mkOption {
    type = lib.types.anything;
  };

  config = lib.mkMerge [
    {
      value.mkiffalse = lib.mkIf false {};
    }
    {
      value.mkiftrue = lib.mkIf true {};
    }
    {
      value.mkdefault = lib.mkDefault 0;
    }
    {
      value.mkdefault = 1;
    }
    {
      value.mkmerge = lib.mkMerge [
        {}
      ];
    }
    {
      value.mkbefore = lib.mkBefore true;
    }
    {
      value.nested = lib.mkMerge [
        {
          foo = lib.mkDefault 0;
          bar = lib.mkIf false 0;
        }
        (lib.mkIf true {
          foo = lib.mkIf true (lib.mkForce 1);
          bar = {
            baz = lib.mkDefault "baz";
          };
        })
      ];
    }
  ];

}
