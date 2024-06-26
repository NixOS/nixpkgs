{ lib, config, ... }: {

  options.valueIsFunction = lib.mkOption {
    default = lib.mapAttrs (name: lib.isFunction) config.value;
  };

  options.value = lib.mkOption {
    type = lib.types.anything;
  };

  options.applied = lib.mkOption {
    default = lib.mapAttrs (name: fun: fun null) config.value;
  };

  config = lib.mkMerge [
    {
      value.single-lambda = x: x;
      value.multiple-lambdas = x: { inherit x; };
      value.merging-lambdas = x: { inherit x; };
    }
    {
      value.multiple-lambdas = x: [ x ];
      value.merging-lambdas = y: { inherit y; };
    }
  ];

}
