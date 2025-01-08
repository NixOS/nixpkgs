{ lib, ... }:
let
  moduleWithoutKey = {
    config = {
      raw = "pear";
    };
  };

  moduleWithKey = {
    key = __curPos.file + "#moduleWithKey";
    config = {
      raw = "pear";
    };
  };

  decl = {
    options = {
      raw = lib.mkOption {
        type = lib.types.lines;
      };
    };
  };
in
{
  options = {
    once = lib.mkOption {
      type = lib.types.submodule {
        imports = [
          decl
          moduleWithKey
          moduleWithKey
        ];
      };
      default = { };
    };
    twice = lib.mkOption {
      type = lib.types.submodule {
        imports = [
          decl
          moduleWithoutKey
          moduleWithoutKey
        ];
      };
      default = { };
    };
  };
}
