{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.openldap;
  legacyOptions = [ "rootpwFile" "suffix" "dataDir" "rootdn" "rootpw" ];
  openldap = cfg.package;
  useDefaultConfDir = cfg.configDir == null;
  configDir = if cfg.configDir != null then cfg.configDir else "/var/lib/openldap/slapd.d";

  dbSettings = filterAttrs (name: value: hasPrefix "olcDatabase=" name) cfg.settings.children;
  dataDirs = mapAttrs' (_: value: nameValuePair value.attrs.olcSuffix (removePrefix "/var/lib/openldap/" value.attrs.olcDbDirectory))
    (lib.filterAttrs (_: value: value.attrs ? olcDbDirectory && hasPrefix "/var/lib/openldap/" value.attrs.olcDbDirectory) dbSettings);
  declarativeDNs = attrNames cfg.declarativeContents;
  additionalStateDirectories = map (sfx: "openldap/" + sfx) (attrValues dataDirs);

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
                  olcDbDirectory = "/var/lib/openldap/db1";
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
          <literal>settings</literal> option. Overrides all NixOS settings.
        '';
        example = "/var/lib/openldap/slapd.d";
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

          Note that the DIT root of the declarative DB must be defined in
          <code>services.openldap.settings</code> AND the <code>olcDbDirectory</code>
          must be prefixed by "/var/lib/openldap/"
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

  meta.maintainers = with lib.maintainers; [ mic92 kwohlfahrt ];

  config = mkIf cfg.enable {
    assertions = map (opt: {
      assertion = ((getAttr opt cfg) != "_mkMergedOptionModule") -> (cfg.database != "_mkMergedOptionModule");
      message = "Legacy OpenLDAP option `services.openldap.${opt}` requires `services.openldap.database` (use value \"mdb\" if unsure)";
    }) legacyOptions ++ map (dn: {
      assertion = dataDirs ? "${dn}";
      message = ''
        declarative DB ${dn} does not exist in "servies.openldap.settings" or it exists but the "olcDbDirectory"
        is not prefixed by "/var/lib/openldap/"
      '';
    }) declarativeDNs;
    environment.systemPackages = [ openldap ];

    # Literal attributes must always be set
    services.openldap.settings = {
      attrs = {
        objectClass = "olcGlobal";
        cn = "config";
        olcPidFile = "/run/openldap/slapd.pid";
      };
      children."cn=schema".attrs = {
        cn = "schema";
        objectClass = "olcSchemaConfig";
      };
    };

    systemd.services.openldap = {
      description = "LDAP server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = let
        settingsFile = pkgs.writeText "config.ldif" (lib.concatStringsSep "\n" (attrsToLdif "cn=config" cfg.settings));
        dataFiles = lib.mapAttrs (dn: contents: pkgs.writeText "${dn}.ldif" contents) cfg.declarativeContents;
        mkLoadScript = dn: let
          dataDir = lib.escapeShellArg ("/var/lib/openldap/" + getAttr dn dataDirs);
        in  ''
          rm -rf ${dataDir}/*
          ${openldap}/bin/slapadd -F ${lib.escapeShellArg configDir} -b ${dn} -l ${getAttr dn dataFiles}
        '';
      in ''
        ${lib.optionalString useDefaultConfDir ''
          rm -rf ${configDir}/*
          ${openldap}/bin/slapadd -F ${configDir} -bcn=config -l ${settingsFile}
        ''}

        ${lib.concatStrings (map mkLoadScript declarativeDNs)}
        ${openldap}/bin/slaptest -u -F ${lib.escapeShellArg configDir}
      '';
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "forking";
        ExecStart = lib.escapeShellArgs ([
          "${openldap}/libexec/slapd" "-F" configDir
          "-h" (lib.concatStringsSep " " cfg.urlList)
        ]);
        StateDirectory = [ "openldap/slapd.d" ] ++ additionalStateDirectories;
        StateDirectoryMode = "700";
        RuntimeDirectory = "openldap";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
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
