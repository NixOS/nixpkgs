{ pkgs, lib, ... }:

# Based on
# - https://web.mit.edu/kerberos/krb5-1.12/doc/admin/conf_files/krb5_conf.html
# - https://manpages.debian.org/unstable/heimdal-docs/krb5.conf.5heimdal.en.html

let
  inherit (lib) boolToString concatMapStringsSep concatStringsSep filter
    isAttrs isBool isList mapAttrsToList mkOption singleton splitString;
  inherit (lib.types) attrsOf bool coercedTo either int listOf oneOf path
    str submodule;
in
{ }: {
  type = let
    section = attrsOf relation;
    relation = either (attrsOf value) value;
    value = either (listOf atom) atom;
    atom = oneOf [int str bool];
  in submodule {
    freeformType = attrsOf section;
    options = {
      include = mkOption {
        default = [ ];
        description = ''
          Files to include in the Kerberos configuration.
        '';
        type = coercedTo path singleton (listOf path);
      };
      includedir = mkOption {
        default = [ ];
        description = ''
          Directories containing files to include in the Kerberos configuration.
        '';
        type = coercedTo path singleton (listOf path);
      };
      module = mkOption {
        default = [ ];
        description = ''
          Modules to obtain Kerberos configuration from.
        '';
        type = coercedTo path singleton (listOf path);
      };
    };
  };

  generate = let
    indent = str: concatMapStringsSep "\n" (line: "  " + line) (splitString "\n" str);

    formatToplevel = args @ {
      include ? [ ],
      includedir ? [ ],
      module ? [ ],
      ...
    }: let
      sections = removeAttrs args [ "include" "includedir" "module" ];
    in concatStringsSep "\n" (filter (x: x != "") [
      (concatStringsSep "\n" (mapAttrsToList formatSection sections))
      (concatMapStringsSep "\n" (m: "module ${m}") module)
      (concatMapStringsSep "\n" (i: "include ${i}") include)
      (concatMapStringsSep "\n" (i: "includedir ${i}") includedir)
    ]);

    formatSection = name: section: ''
      [${name}]
      ${indent (concatStringsSep "\n" (mapAttrsToList formatRelation section))}
    '';

    formatRelation = name: relation:
      if isAttrs relation
      then ''
        ${name} = {
        ${indent (concatStringsSep "\n" (mapAttrsToList formatValue relation))}
        }''
      else formatValue name relation;

    formatValue = name: value:
      if isList value
      then concatMapStringsSep "\n" (formatAtom name) value
      else formatAtom name value;

    formatAtom = name: atom: let
      v = if isBool atom then boolToString atom else toString atom;
    in "${name} = ${v}";
  in
    name: value: pkgs.writeText name ''
      ${formatToplevel value}
    '';
}
