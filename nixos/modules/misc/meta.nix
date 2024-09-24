{ lib, ... }:

with lib;

let
  maintainer = mkOptionType {
    name = "maintainer";
    check = email: elem email (attrValues lib.maintainers);
    merge = loc: defs: listToAttrs (singleton (nameValuePair (last defs).file (last defs).value));
  };

  listOfMaintainers = types.listOf maintainer // {
    # Returns list of
    #   { "module-file" = [
    #        "maintainer1 <first@nixos.org>"
    #        "maintainer2 <second@nixos.org>" ];
    #   }
    merge = loc: defs:
      zipAttrs
        (flatten (imap1 (n: def: imap1 (m: def':
          maintainer.merge (loc ++ ["[${toString n}-${toString m}]"])
            [{ inherit (def) file; value = def'; }]) def.value) defs));
  };

  docFile = types.path // {
    # Returns tuples of
    #   { file = "module location"; value = <path/to/doc.xml>; }
    merge = loc: defs: defs;
  };
in

{
  options = {
    meta = {

      maintainers = mkOption {
        type = listOfMaintainers;
        internal = true;
        default = [];
        example = literalExpression ''[ lib.maintainers.all ]'';
        description = ''
          List of maintainers of each module.  This option should be defined at
          most once per module.
        '';
      };

      doc = mkOption {
        type = docFile;
        internal = true;
        example = "./meta.chapter.md";
        description = ''
          Documentation prologue for the set of options of each module.  This
          option should be defined at most once per module.
        '';
      };

      buildDocsInSandbox = mkOption {
        type = types.bool // {
          merge = loc: defs: defs;
        };
        internal = true;
        default = true;
        description = ''
          Whether to include this module in the split options doc build.
          Disable if the module references `config`, `pkgs` or other module
          arguments that cannot be evaluated as constants.

          This option should be defined at most once per module.
        '';
      };

    };
  };

  meta.maintainers = singleton lib.maintainers.pierron;
}
