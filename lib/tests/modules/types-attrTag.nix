{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  forceDeep = x: builtins.deepSeq x x;
in
{
  options = {
    intStrings = mkOption {
      type = types.attrsOf
        (types.attrTag {
          left = types.int;
          right = types.str;
        });
    };
    nested = mkOption {
      type = types.attrTag {
        left = types.int;
        right = types.attrTag {
          left = types.int;
          right = types.str;
        };
      };
    };
    merged = mkOption {
      type = types.attrsOf (
        types.attrTag {
          yay = types.int;
        }
      );
    };
    okChecks = mkOption {};
  };
  imports = [
    {
      options.merged = mkOption {
        type = types.attrsOf (
          types.attrTag {
            nay = types.bool;
          }
        );
      };
    }
  ];
  config = {
    intStrings.syntaxError = 1;
    intStrings.syntaxError2 = {};
    intStrings.syntaxError3 = { a = true; b = true; };
    intStrings.syntaxError4 = lib.mkMerge [ { a = true; } { b = true; } ];
    intStrings.mergeError = lib.mkMerge [ { int = throw "do not eval"; } { string = throw "do not eval"; } ];
    intStrings.badTagError.rite = throw "do not eval";
    intStrings.badTagTypeError.left = "bad";
    intStrings.numberOne.left = 1;
    intStrings.hello.right = "hello world";
    nested.right.left = "not a number";
    merged.negative.nay = false;
    merged.positive.yay = 100;
    okChecks =
      assert config.intStrings.hello.right == "hello world";
      assert config.intStrings.numberOne.left == 1;
      assert config.merged.negative.nay == false;
      assert config.merged.positive.yay == 100;
      true;
  };
}
