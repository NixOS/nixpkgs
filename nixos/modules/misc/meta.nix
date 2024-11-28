{ lib, ... }:

with lib;

let
  maintainer = mkOptionType {
    name = "maintainer";
    check = email: elem email (attrValues lib.maintainers);
    merge = _: defs: listToAttrs (singleton (nameValuePair (last defs).file (last defs).value));
  };

  moduleListOf = type: types.listOf type // {
    # Returns list of
    #   {
    #     "module-file" = [ type.value ];
    #   }
    merge = loc: defs:
      listToAttrs (map (def: nameValuePair def.file def.value) defs);
  };

  listOfMaintainers = types.listOf maintainer // {
    # Returns list of
    #   { "module-file" = [
    #        "maintainer1 <first@nixos.org>"
    #        "maintainer2 <second@nixos.org>" ];
    #   }
    merge = _: defs:
      zipAttrs
        (flatten (imap1 (n: def: imap1 (m: def':
          maintainer.merge null
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

      wikiPages = mkOption {
        type = moduleListOf types.str;
        internal = true;
        default = [];
        example = [
          "https://wiki.nixos.org/wiki/NixOS"
        ];
        # TODO better description!
        description = ''
          A link to a NixOS wiki page for this module.
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
