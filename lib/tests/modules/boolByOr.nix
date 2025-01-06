{ lib, ... }: {

  options.value = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.boolByOr;
  };

  config.value = {
    falseFalse = lib.mkMerge [ false false ];
    trueFalse = lib.mkMerge [ true false ];
    falseTrue = lib.mkMerge [ false true ];
    trueTrue = lib.mkMerge [ true true ];
  };
}

