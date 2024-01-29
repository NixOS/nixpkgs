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
    submodules = mkOption {
      type = types.attrsOf (
        types.attrTag {
          foo = types.submodule {
            options = {
              bar = mkOption {
                type = types.int;
              };
            };
          };
          qux = types.str;
        }
      );
    };
    okChecks = mkOption {};
  };
  imports = [
    ./docs.nix
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
      # assert lib.foldl' (a: b: builtins.trace b a) true (lib.attrNames config.docs);
      assert config.docs."submodules.<name>.foo.bar".type == "signed integer";
      # It's not an option, so we can't render it as such. Something would be nice though.
      assert ! (config.docs?"submodules.<name>.qux");
      true;
  };
}
