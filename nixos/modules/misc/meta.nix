{ lib, ... }:
let
  maintainer = lib.mkOptionType {
    name = "maintainer";
    check = email: lib.elem email (lib.attrValues lib.maintainers);
    merge =
      loc: defs:
      lib.listToAttrs (lib.singleton (lib.nameValuePair (lib.last defs).file (lib.last defs).value));
  };

  listOfMaintainers = lib.types.listOf maintainer // {
    # Returns list of
    #   { "module-file" = [
    #        "maintainer1 <first@nixos.org>"
    #        "maintainer2 <second@nixos.org>" ];
    #   }
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

  docFile = lib.types.path // {
    # Returns tuples of
    #   { file = "module location"; value = <path/to/doc.xml>; }
    merge = loc: defs: defs;
  };
in

{
  options = {
    meta = {

      maintainers = lib.mkOption {
        type = listOfMaintainers;
        internal = true;
        default = [ ];
        example = lib.literalExpression ''[ lib.maintainers.all ]'';
        description = ''
          List of maintainers of each module.  This option should be defined at
          most once per module.
        '';
      };

      doc = lib.mkOption {
        type = docFile;
        internal = true;
        example = "./meta.chapter.md";
        description = ''
          Documentation prologue for the set of options of each module.  This
          option should be defined at most once per module.
        '';
      };

      buildDocsInSandbox = lib.mkOption {
        type = lib.types.bool // {
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

  meta.maintainers = lib.singleton lib.maintainers.pierron;
}
