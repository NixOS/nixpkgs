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
        example = [ lib.maintainers.all ];
        description = ''
          List of maintainers of each module.  This option should be defined at
          most once per module.
        '';
      };

      doc = mkOption {
        type = docFile;
        internal = true;
        example = "./meta.chapter.xml";
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
        default = false;
        description = ''
          This is an effectless placeholder, so modules from master don't fail to evaluate on systems based on nixos-21.11.
          See <link xlink:href="https://github.com/NixOS/nixpkgs/pull/149532"/>
        '';
      };

    };
  };

  meta.maintainers = singleton lib.maintainers.pierron;
}
