{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.openldap;
  legacyOptions = [ "rootpwFile" "suffix" "dataDir" "rootdn" "rootpw" ];
  openldap = cfg.package;
  configDir = if cfg.configDir != null then cfg.configDir else "/etc/openldap/slapd.d";

  ldapValueType = let
    # Can't do types.either with multiple non-overlapping submodules, so define our own
    singleLdapValueType = lib.mkOptionType rec {
      name = "LDAP";
      description = "LDAP value";
      check = x: lib.isString x || (lib.isAttrs x && (x ? path || x ? base64));
      merge = lib.mergeEqualOption;
    };
    # We don't coerce to lists of single values, as some values must be unique
  in types.either singleLdapValueType (types.listOf singleLdapValueType);

  ldapAttrsType =
    let
      options = {
        attrs = mkOption {
          type = types.attrsOf ldapValueType;
          default = {};
          description = "Attributes of the parent entry.";
        };
        children = mkOption {
          # Hide the child attributes, to avoid infinite recursion in e.g. documentation
          # Actual Nix evaluation is lazy, so this is not an issue there
          type = let
            hiddenOptions = lib.mapAttrs (name: attr: attr // { visible = false; }) options;
          in types.attrsOf (types.submodule { options = hiddenOptions; });
          default = {};
          description = "Child entries of the current entry, with recursively the same structure.";
          example = lib.literalExpression ''
            {
                "cn=schema" = {
                # The attribute used in the DN must be defined
                attrs = { cn = "schema"; };
                children = {
                    # This entry's DN is expanded to "cn=foo,cn=schema"
                    "cn=foo" = { ... };
                };
                # These includes are inserted after "cn=schema", but before "cn=foo,cn=schema"
                includes = [ ... ];
                };
            }
          '';
        };
        includes = mkOption {
          type = types.listOf types.path;
          default = [];
          description = ''
            LDIF files to include after the parent's attributes but before its children.
          '';
        };
      };
    in types.submodule { inherit options; };

  valueToLdif = attr: values: let
    listValues = if lib.isList values then values else lib.singleton values;
  in map (value:
    if lib.isAttrs value then
      if lib.hasAttr "path" value
      then "${attr}:< file://${value.path}"
      else "${attr}:: ${value.base64}"
    else "${attr}: ${lib.replaceStrings [ "\n" ] [ "\n " ] value}"
  ) listValues;

  attrsToLdif = dn: { attrs, children, includes, ... }: [''
    dn: ${dn}
    ${lib.concatStringsSep "\n" (lib.flatten (lib.mapAttrsToList valueToLdif attrs))}
  ''] ++ (map (path: "include: file://${path}\n") includes) ++ (
    lib.flatten (lib.mapAttrsToList (name: value: attrsToLdif "${name},${dn}" value) children)
  );
in {
  imports = let
    deprecationNote = "This option is removed due to the deprecation of `slapd.conf` upstream. Please migrate to `services.openldap.settings`, see the release notes for advice with this process.";
    mkDatabaseOption = old: new:
      lib.mkChangedOptionModule [ "services" "openldap" old ] [ "services" "openldap" "settings" "children" ]
        (config: let
          database = lib.getAttrFromPath [ "services" "openldap" "database" ] config;
          value = lib.getAttrFromPath [ "services" "openldap" old ] config;
        in lib.setAttrByPath ([ "olcDatabase={1}${database}" "attrs" ] ++ new) value);
  in [
    (lib.mkRemovedOptionModule [ "services" "openldap" "extraConfig" ] deprecationNote)
    (lib.mkRemovedOptionModule [ "services" "openldap" "extraDatabaseConfig" ] deprecationNote)

    (lib.mkChangedOptionModule [ "services" "openldap" "logLevel" ] [ "services" "openldap" "settings" "attrs" "olcLogLevel" ]
      (config: lib.splitString " " (lib.getAttrFromPath [ "services" "openldap" "logLevel" ] config)))
    (lib.mkChangedOptionModule [ "services" "openldap" "defaultSchemas" ] [ "services" "openldap" "settings" "children" "cn=schema" "includes"]
      (config: lib.optionals (lib.getAttrFromPath [ "services" "openldap" "defaultSchemas" ] config) (
        map (schema: "${openldap}/etc/schema/${schema}.ldif") [ "core" "cosine" "inetorgperson" "nis" ])))

    (lib.mkChangedOptionModule [ "services" "openldap" "database" ] [ "services" "openldap" "settings" "children" ]
      (config: let
        database = lib.getAttrFromPath [ "services" "openldap" "database" ] config;
      in {
        "olcDatabase={1}${database}".attrs = {
          # objectClass is case-insensitive, so don't need to capitalize ${database}
          objectClass = [ "olcdatabaseconfig" "olc${database}config" ];
          olcDatabase = "{1}${database}";
          olcDbDirectory = lib.mkDefault "/var/db/openldap";
        };
        "cn=schema".includes = lib.mkDefault (
          map (schema: "${openldap}/etc/schema/${schema}.ldif") [ "core" "cosine" "inetorgperson" "nis" ]
        );
      }))
    (mkDatabaseOption "rootpwFile" [ "olcRootPW" "path" ])
    (mkDatabaseOption "suffix" [ "olcSuffix" ])
    (mkDatabaseOption "dataDir" [ "olcDbDirectory" ])
    (mkDatabaseOption "rootdn" [ "olcRootDN" ])
    (mkDatabaseOption "rootpw" [ "olcRootPW" ])
  ];
  options = {
    services.openldap = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "
          Whether to enable the ldap server.
        ";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.openldap;
        defaultText = literalExpression "pkgs.openldap";
        description = ''
          OpenLDAP package to use.

          This can be used to, for example, set an OpenLDAP package
          with custom overrides to enable modules or other
          functionality.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "openldap";
        description = "User account under which slapd runs.";
      };

      group = mkOption {
        type = types.str;
        default = "openldap";
        description = "Group account under which slapd runs.";
      };

      urlList = mkOption {
        type = types.listOf types.str;
        default = [ "ldap:///" ];
        description = "URL list slapd should listen on.";
        example = [ "ldaps:///" ];
      };

      settings = mkOption {
        type = ldapAttrsType;
        description = "Configuration for OpenLDAP, in OLC format";
        example = lib.literalExpression ''
          {
            attrs.olcLogLevel = [ "stats" ];
            children = {
              "cn=schema".includes = [
                 "''${pkgs.openldap}/etc/schema/core.ldif"
                 "''${pkgs.openldap}/etc/schema/cosine.ldif"
                 "''${pkgs.openldap}/etc/schema/inetorgperson.ldif"
              ];
              "olcDatabase={-1}frontend" = {
                attrs = {
                  objectClass = "olcDatabaseConfig";
                  olcDatabase = "{-1}frontend";
                  olcAccess = [ "{0}to * by dn.exact=uidNumber=0+gidNumber=0,cn=peercred,cn=external,cn=auth manage stop by * none stop" ];
                };
              };
              "olcDatabase={0}config" = {
                attrs = {
                  objectClass = "olcDatabaseConfig";
                  olcDatabase = "{0}config";
                  olcAccess = [ "{0}to * by * none break" ];
                };
              };
              "olcDatabase={1}mdb" = {
                attrs = {
                  objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
                  olcDatabase = "{1}mdb";
                  olcDbDirectory = "/var/db/ldap";
                  olcDbIndex = [
                    "objectClass eq"
                    "cn pres,eq"
                    "uid pres,eq"
                    "sn pres,eq,subany"
                  ];
                  olcSuffix = "dc=example,dc=com";
                  olcAccess = [ "{0}to * by * read break" ];
                };
              };
            };
          };
        '';
      };

      # This option overrides settings
      configDir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Use this config directory instead of generating one from the
          <literal>settings</literal> option. Overrides all NixOS settings. If
          you use this option,ensure `olcPidFile` is set to `/run/slapd/slapd.conf`.
        '';
        example = "/var/db/slapd.d";
      };

      declarativeContents = mkOption {
        type = with types; attrsOf lines;
        default = {};
        description = ''
          Declarative contents for the LDAP database, in LDIF format by suffix.

          All data will be erased when starting the LDAP server. Modifications
          to the database are not prevented, they are just dropped on the next
          reboot of the server. Performance-wise the database and indexes are
          rebuilt on each server startup, so this will slow down server startup,
          especially with large databases.
        '';
        example = lib.literalExpression ''
          {
            "dc=example,dc=org" = '''
              dn= dn: dc=example,dc=org
              objectClass: domain
              dc: example

              dn: ou=users,dc=example,dc=org
              objectClass = organizationalUnit
              ou: users

              # ...
            ''';
          }
        '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ kwohlfahrt ];

  config = mkIf cfg.enable {
    assertions = map (opt: {
      assertion = ((getAttr opt cfg) != "_mkMergedOptionModule") -> (cfg.database != "_mkMergedOptionModule");
      message = "Legacy OpenLDAP option `services.openldap.${opt}` requires `services.openldap.database` (use value \"mdb\" if unsure)";
    }) legacyOptions;
    environment.systemPackages = [ openldap ];

    # Literal attributes must always be set
    services.openldap.settings = {
      attrs = {
        objectClass = "olcGlobal";
        cn = "config";
        olcPidFile = "/run/slapd/slapd.pid";
      };
      children."cn=schema".attrs = {
        cn = "schema";
        objectClass = "olcSchemaConfig";
      };
    };

    systemd.services.openldap = {
      description = "OpenLDAP Server Daemon";
      documentation = [
        "man:slapd"
        "man:slapd-config"
        "man:slapd-mdb"
      ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      preStart = let
        settingsFile = pkgs.writeText "config.ldif" (lib.concatStringsSep "\n" (attrsToLdif "cn=config" cfg.settings));

        dbSettings = lib.filterAttrs (name: value: lib.hasPrefix "olcDatabase=" name) cfg.settings.children;
        dataDirs = lib.mapAttrs' (name: value: lib.nameValuePair value.attrs.olcSuffix value.attrs.olcDbDirectory)
          (lib.filterAttrs (_: value: value.attrs ? olcDbDirectory) dbSettings);
        dataFiles = lib.mapAttrs (dn: contents: pkgs.writeText "${dn}.ldif" contents) cfg.declarativeContents;
        mkLoadScript = dn: let
          dataDir = lib.escapeShellArg (getAttr dn dataDirs);
        in  ''
          rm -rf ${dataDir}/*
          ${openldap}/bin/slapadd -F ${lib.escapeShellArg configDir} -b ${dn} -l ${getAttr dn dataFiles}
          chown -R "${cfg.user}:${cfg.group}" ${dataDir}
        '';
      in ''
        mkdir -p /run/slapd
        chown -R "${cfg.user}:${cfg.group}" /run/slapd

        mkdir -p ${lib.escapeShellArg configDir} ${lib.escapeShellArgs (lib.attrValues dataDirs)}
        chown "${cfg.user}:${cfg.group}" ${lib.escapeShellArg configDir} ${lib.escapeShellArgs (lib.attrValues dataDirs)}

        ${lib.optionalString (cfg.configDir == null) (''
          rm -Rf ${configDir}/*
          ${openldap}/bin/slapadd -F ${configDir} -bcn=config -l ${settingsFile}
        '')}
        chown -R "${cfg.user}:${cfg.group}" ${lib.escapeShellArg configDir}

        ${lib.concatStrings (map mkLoadScript (lib.attrNames cfg.declarativeContents))}
        ${openldap}/bin/slaptest -u -F ${lib.escapeShellArg configDir}
      '';
      serviceConfig = {
        ExecStart = lib.escapeShellArgs ([
          "${openldap}/libexec/slapd" "-u" cfg.user "-g" cfg.group "-F" configDir
          "-h" (lib.concatStringsSep " " cfg.urlList)
        ]);
        Type = "notify";
        NotifyAccess = "all";
        PIDFile = cfg.settings.attrs.olcPidFile;
      };
    };

    users.users = lib.optionalAttrs (cfg.user == "openldap") {
      openldap = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "openldap") {
      openldap = {};
    };
  };
}
