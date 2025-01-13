{ lib, optionDeclaration, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    defaultText = mkOption {
      apply =
        v: if v == null && !optionDeclaration ? default then null else lib.options.renderOptionValue v;
      type = types.raw;
      default = optionDeclaration.default or null;
    };
    example = mkOption {
      apply =
        v: if v == null && !optionDeclaration ? default then null else lib.options.renderOptionValue v;
      type = types.raw;
      default = optionDeclaration.example or null;
    };
    description = mkOption {
      type = types.nullOr types.str;
      default = optionDeclaration.description or null;
    };
    internal = mkOption {
      type = types.bool;
      default = optionDeclaration.internal or false;
    };
    visible = mkOption {
      type = types.enum [
        true
        false
        "shallow"
      ];
      default = optionDeclaration.visible or true;
    };
  };
}
