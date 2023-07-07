{ lib, ... }: {
  options.value = lib.mkOption {
    type = lib.types.oneOf [
      lib.types.int
      (lib.types.listOf lib.types.int)
      lib.types.str
    ];
  };
}
