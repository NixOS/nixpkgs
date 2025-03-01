{ lib, config, ... }:
{

  options = {
    processedToplevel = lib.mkOption {
      type = lib.types.raw;
    };
    unprocessedNesting = lib.mkOption {
      type = lib.types.raw;
    };
    multiple = lib.mkOption {
      type = lib.types.raw;
    };
    priorities = lib.mkOption {
      type = lib.types.raw;
    };
    unprocessedNestingEvaluates = lib.mkOption {
      default = builtins.tryEval config.unprocessedNesting;
    };
  };

  config = {
    processedToplevel = lib.mkIf true 10;
    unprocessedNesting.foo = throw "foo";
    multiple = lib.mkMerge [
      "foo"
      "foo"
    ];
    priorities = lib.mkMerge [
      "foo"
      (lib.mkForce "bar")
    ];
  };
}
