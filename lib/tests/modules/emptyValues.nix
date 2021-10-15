{ lib, ... }: {

  options = {
    int = lib.mkOption {
      type = lib.types.int;
    };
    list = lib.mkOption {
      type = lib.types.listOf lib.types.int;
    };
    nonEmptyList = lib.mkOption {
      type = lib.types.nonEmptyListOf lib.types.int;
    };
    attrs = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
    };
    null = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
    };
    submodule = lib.mkOption {
      type = lib.types.submodule {};
    };
  };

}
