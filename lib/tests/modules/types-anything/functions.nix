{ lib, ... }: {

  options.value = lib.mkOption {
    type = lib.types.anything;
  };

  config = lib.mkMerge [
    {
      value.single-lambda = x: x;
      value.multiple-lambdas = x: x;
    }
    {
      value.multiple-lambdas = x: x;
    }
  ];

}
