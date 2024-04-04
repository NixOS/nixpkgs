{ lib, config, options, ... }:
let
  inherit (lib) mkOption types;
  forceDeep = x: builtins.deepSeq x x;
  mergedSubOption = (options.merged.type.getSubOptions options.merged.loc).extensible."merged.<name>";
in
{
  options = {
    intStrings = mkOption {
      type = types.attrsOf
        (types.attrTag {
          left = mkOption {
            type = types.int;
          };
          right = mkOption {
            type = types.str;
          };
        });
    };
    nested = mkOption {
      type = types.attrTag {
        left = mkOption {
          type = types.int;
        };
        right = mkOption {
          type = types.attrTag {
            left = mkOption {
              type = types.int;
            };
            right = mkOption {
              type = types.str;
            };
          };
        };
      };
    };
    merged = mkOption {
      type = types.attrsOf (
        types.attrTag {
          yay = mkOption {
            type = types.int;
          };
          extensible = mkOption {
            type = types.enum [ "foo" ];
          };
        }
      );
    };
    submodules = mkOption {
      type = types.attrsOf (
        types.attrTag {
          foo = mkOption {
            type = types.submodule {
              options = {
                bar = mkOption {
                  type = types.int;
                };
              };
            };
          };
          qux = mkOption {
            type = types.str;
            description = "A qux for when you don't want a foo";
          };
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
            nay = mkOption {
              type = types.bool;
            };
            extensible = mkOption {
              type = types.enum [ "bar" ];
            };
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
    merged.extensi-foo.extensible = "foo";
    merged.extensi-bar.extensible = "bar";
    okChecks = builtins.addErrorContext "while evaluating the assertions" (
      assert config.intStrings.hello == { right = "hello world"; };
      assert config.intStrings.numberOne == { left = 1; };
      assert config.merged.negative == { nay = false; };
      assert config.merged.positive == { yay = 100; };
      assert config.merged.extensi-foo == { extensible = "foo"; };
      assert config.merged.extensi-bar == { extensible = "bar"; };
      assert config.docs."submodules.<name>.foo.bar".type == "signed integer";
      assert config.docs."submodules.<name>.qux".type == "string";
      assert config.docs."submodules.<name>.qux".declarations == [ __curPos.file ];
      assert config.docs."submodules.<name>.qux".loc == [ "submodules" "<name>" "qux" ];
      assert config.docs."submodules.<name>.qux".name == "submodules.<name>.qux";
      assert config.docs."submodules.<name>.qux".description == "A qux for when you don't want a foo";
      assert config.docs."submodules.<name>.qux".readOnly == false;
      assert config.docs."submodules.<name>.qux".visible == true;
      # Not available (yet?)
      # assert config.docs."submodules.<name>.qux".declarationsWithPositions == [ ... ];
      assert options.submodules.declarations == [ __curPos.file ];
      assert lib.length options.submodules.declarationPositions == 1;
      assert (lib.head options.submodules.declarationPositions).file == __curPos.file;
      assert options.merged.declarations == [ __curPos.file __curPos.file ];
      assert lib.length options.merged.declarationPositions == 2;
      assert (lib.elemAt options.merged.declarationPositions 0).file == __curPos.file;
      assert (lib.elemAt options.merged.declarationPositions 1).file == __curPos.file;
      assert (lib.elemAt options.merged.declarationPositions 0).line != (lib.elemAt options.merged.declarationPositions 1).line;
      assert mergedSubOption.declarations == [ __curPos.file __curPos.file ];
      assert lib.length mergedSubOption.declarationPositions == 2;
      assert (lib.elemAt mergedSubOption.declarationPositions 0).file == __curPos.file;
      assert (lib.elemAt mergedSubOption.declarationPositions 1).file == __curPos.file;
      assert (lib.elemAt mergedSubOption.declarationPositions 0).line != (lib.elemAt mergedSubOption.declarationPositions 1).line;
      assert lib.length config.docs."merged.<name>.extensible".declarations == 2;
      true);
  };
}
