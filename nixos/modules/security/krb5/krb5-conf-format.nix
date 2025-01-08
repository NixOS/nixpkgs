{ pkgs, lib, ... }:

# Based on
# - https://web.mit.edu/kerberos/krb5-1.12/doc/admin/conf_files/krb5_conf.html
# - https://manpages.debian.org/unstable/heimdal-docs/krb5.conf.5heimdal.en.html

{
  enableKdcACLEntries ? false,
}:
rec {
  sectionType =
    let
      relation = lib.types.oneOf [
        (lib.types.listOf (lib.types.attrsOf value))
        (lib.types.attrsOf value)
        value
      ];
      value = lib.types.either (lib.types.listOf atom) atom;
      atom = lib.types.oneOf [
        lib.types.int
        lib.types.str
        lib.types.bool
      ];
    in
    lib.types.attrsOf relation;

  type =
    let
      aclEntry = lib.types.submodule {
        options = {
          principal = lib.mkOption {
            type = lib.types.str;
            description = "Which principal the rule applies to";
          };
          access = lib.mkOption {
            type = lib.types.either (lib.types.listOf (lib.types.enum [
              "add"
              "cpw"
              "delete"
              "get"
              "list"
              "modify"
            ])) (lib.types.enum [ "all" ]);
            default = "all";
            description = "The changes the principal is allowed to make.";
          };
          target = lib.mkOption {
            type = lib.types.str;
            default = "*";
            description = "The principals that 'access' applies to.";
          };
        };
      };

      realm = lib.types.submodule (
        { name, ... }:
        {
          freeformType = sectionType;
          options = {
            acl = lib.mkOption {
              type = lib.types.listOf aclEntry;
              default = [
                {
                  principal = "*/admin";
                  access = "all";
                }
                {
                  principal = "admin";
                  access = "all";
                }
              ];
              description = ''
                The privileges granted to a user.
              '';
            };
          };
        }
      );
    in
    lib.types.submodule {
      freeformType = lib.types.attrsOf sectionType;
      options =
        {
          include = lib.mkOption {
            default = [ ];
            description = ''
              Files to include in the Kerberos configuration.
            '';
            type = lib.types.coercedTo lib.types.path lib.types.singleton (lib.types.listOf lib.types.path);
          };
          includedir = lib.mkOption {
            default = [ ];
            description = ''
              Directories containing files to include in the Kerberos configuration.
            '';
            type = lib.types.coercedTo lib.types.path lib.types.singleton (lib.types.listOf lib.types.path);
          };
          module = lib.mkOption {
            default = [ ];
            description = ''
              Modules to obtain Kerberos configuration from.
            '';
            type = lib.types.coercedTo lib.types.path lib.types.singleton (lib.types.listOf lib.types.path);
          };

        }
        // (lib.optionalAttrs enableKdcACLEntries {
          realms = lib.mkOption {
            type = lib.types.attrsOf realm;
            description = ''
              The realm(s) to serve keys for.
            '';
          };
        });
    };

  generate =
    let
      indent = str: lib.concatMapStringsSep "\n" (line: "  " + line) (lib.splitString "\n" str);

      formatToplevel =
        args@{
          include ? [ ],
          includedir ? [ ],
          module ? [ ],
          ...
        }:
        let
          sections = removeAttrs args [
            "include"
            "includedir"
            "module"
          ];
        in
        lib.concatStringsSep "\n" (
          lib.filter (x: x != "") [
            (lib.concatStringsSep "\n" (lib.mapAttrsToList formatSection sections))
            (lib.concatMapStringsSep "\n" (m: "module ${m}") module)
            (lib.concatMapStringsSep "\n" (i: "include ${i}") include)
            (lib.concatMapStringsSep "\n" (i: "includedir ${i}") includedir)
          ]
        );

      formatSection = name: section: ''
        [${name}]
        ${indent (lib.concatStringsSep "\n" (lib.mapAttrsToList formatRelation section))}
      '';

      formatRelation =
        name: relation:
        if lib.isAttrs relation then
          ''
            ${name} = {
            ${indent (lib.concatStringsSep "\n" (lib.mapAttrsToList formatValue relation))}
            }''
        else if lib.isList relation then
          lib.concatMapStringsSep "\n" (formatRelation name) relation
        else
          formatValue name relation;

      formatValue =
        name: value:
        if lib.isList value then lib.concatMapStringsSep "\n" (formatAtom name) value else formatAtom name value;

      formatAtom =
        name: atom:
        let
          v = if lib.isBool atom then lib.boolToString atom else toString atom;
        in
        "${name} = ${v}";
    in
    name: value:
    pkgs.writeText name ''
      ${formatToplevel value}
    '';
}
