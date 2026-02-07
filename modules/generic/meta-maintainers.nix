# Test:
#   ./meta-maintainers/test.nix
{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  # The resulting value of this type shows where all values were defined
  sourceList = types.listOf types.raw // {
    merge = loc: defs: lib.listToAttrs (lib.map ({ file, value }: lib.nameValuePair file value) defs);
  };
in
{
  _class = null; # not specific to NixOS
  options = {
    meta = {
      maintainers = mkOption {
        type = sourceList;
        default = [ ];
        example = lib.literalExpression "[ lib.maintainers.alice lib.maintainers.bob ]";
        description = ''
          List of maintainers of each module.
          This option should be defined at most once per module.

          The option value is not a list of maintainers, but an attribute set that maps module file names to lists of maintainers.
        '';
      };
    };
  };
  meta.maintainers = with lib.maintainers; [
    pierron
    roberth
  ];
}
