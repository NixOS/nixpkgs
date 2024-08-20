{ lib, ... }: {

  options.value = lib.mkOption {
    type = lib.types.anything;
  };

  config = lib.mkMerge [
    {
      value.int = 0;
      value.bool = false;
      value.string = "";
      value.path = ./.;
      value.null = null;
      value.float = 0.1;
    }
    {
      value.int = 0;
      value.bool = false;
      value.string = "";
      value.path = ./.;
      value.null = null;
      value.float = 0.1;
    }
  ];

}
