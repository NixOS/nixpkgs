# Test:
#   ./meta-maintainers/test.nix
{ lib, ... }:
let
  inherit (lib)
    mkOption
    mkOptionType
    types
    ;

  maintainer = mkOptionType {
    name = "maintainer";
    check = email: lib.elem email (lib.attrValues lib.maintainers);
    merge = loc: defs: {
      # lib.last: Perhaps this could be merged instead, if "at most once per module"
      # is a problem (see option description).
      ${(lib.last defs).file} = (lib.last defs).value;
    };
  };

  listOfMaintainers = types.listOf maintainer // {
    merge =
      loc: defs:
      lib.zipAttrs (
        lib.flatten (
          lib.imap1 (
            n: def:
            lib.imap1 (
              m: def':
              maintainer.merge (loc ++ [ "[${toString n}-${toString m}]" ]) [
                {
                  inherit (def) file;
                  value = def';
                }
              ]
            ) def.value
          ) defs
        )
      );
  };
in
{
  _class = null; # not specific to NixOS
  options = {
    meta = {
      maintainers = mkOption {
        type = listOfMaintainers;
        default = [ ];
        example = lib.literalExpression ''[ lib.maintainers.alice lib.maintainers.bob ]'';
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
