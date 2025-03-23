{ lib, ... }:
let
  inherit (lib) mkOption types;

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
      raw = mkOption {
        type = types.lines;
      };
    };
  };
in
{
  options = {
    once = mkOption {
      type = types.submodule {
        imports = [
          decl
          moduleWithKey
          moduleWithKey
        ];
      };
      default = { };
    };
    twice = mkOption {
      type = types.submodule {
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
