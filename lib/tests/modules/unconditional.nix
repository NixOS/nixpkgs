{ lib, config, ... }: {

  options = {
    ifTrue = lib.mkOption {
      type = lib.types.unconditional lib.types.int;
    };
    ifFalse = lib.mkOption {
      type = lib.types.unconditional lib.types.int;
    };
    attrsIfTrue = lib.mkOption {
      type = lib.types.attrsOf (lib.types.unconditional lib.types.int);
    };
    attrsIfFalse = lib.mkOption {
      type = lib.types.attrsOf (lib.types.unconditional lib.types.int);
    };
    attrKeys = lib.mkOption {
      default = lib.attrNames config.attrsIfFalse;
    };
    listIfTrue = lib.mkOption {
      type = lib.types.listOf (lib.types.unconditional lib.types.int);
    };
    listIfFalse = lib.mkOption {
      type = lib.types.listOf (lib.types.unconditional lib.types.int);
    };
    listLength = lib.mkOption {
      default = lib.length config.listIfFalse;
    };
  };

  config = {
    ifTrue = lib.mkIf true 10;
    ifFalse = lib.mkIf false 10;
    attrsIfTrue.foo = lib.mkIf true 10;
    attrsIfFalse.foo = lib.mkIf false 10;
    listIfTrue = [ (lib.mkIf true 10) ];
    listIfFalse = [ (lib.mkIf false 10) ];
  };


}
