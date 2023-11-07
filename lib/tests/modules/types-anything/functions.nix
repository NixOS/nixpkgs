{ lib, config, ... }:
{

  options.valueIsFunction = lib.mkOption {
    default = lib.mapAttrs (name: lib.isFunction) config.value;
  };

  options.value = lib.mkOption {
    type = lib.types.anything;
  };

  options.applied = lib.mkOption {
    default = lib.mapAttrs (name: fun:
      if name == "merging-args"
      then
        {
          args =
            let x = lib.functionArgs fun;
            in builtins.deepSeq x x;
          value =
            let x = fun { a = 1; b = 2; };
            # can't pass --strict easily
            in builtins.deepSeq x x;
        }
      else fun null) config.value;
  };

  config = lib.mkMerge [
    {
      value.single-lambda = x: x;
      value.multiple-lambdas = x: { inherit x; };
      value.merging-lambdas = x: { inherit x; };
      value.merging-args = args@{ a, ... }: { p = a; };
    }
    {
      value.multiple-lambdas = x: [ x ];
      value.merging-lambdas = y: { inherit y; };
      value.merging-args = args@{ b, ... }: { q = b; };
    }
  ];

}
