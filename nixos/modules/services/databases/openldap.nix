{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.openldap;
  openldap = cfg.package;
  configDir = if cfg.configDir != null then cfg.configDir else "/etc/openldap/slapd.d";

  ldapValueType = let
    # Can't do types.either with multiple non-overlapping submodules, so define our own
    singleLdapValueType = lib.mkOptionType rec {
      name = "LDAP";
      # TODO: It would be nice to define a { secret = ...; } option, using
      # systemd's LoadCredentials for secrets. That would remove the last
      # barrier to using DynamicUser for openldap. This is blocked on
      # systemd/systemd#19604
      description = ''
        LDAP value - either a string, or an attrset containing
        `path` or `base64` for included
        values or base-64 encoded values respectively.
      '';
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
          description = lib.mdDoc "Attributes of the parent entry.";
        };
        children = mkOption {
          # Hide the child attributes, to avoid infinite recursion in e.g. documentation
          # Actual Nix evaluation is lazy, so this is not an issue there
          type = let
            hiddenOptions = lib.mapAttrs (name: attr: attr // { visible = false; }) options;
          in types.attrsOf (types.submodule { options = hiddenOptions; });
          default = {};
          description = lib.mdDoc "Child entries of the current entry, with recursively the same structure.";
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
          description = lib.mdDoc ''
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
        description = lib.mdDoc "Whether to enable the ldap server.";
      };

      package = mkPackageOption pkgs "openldap" {
        extraDescription = ''
          This can be used to, for example, set an OpenLDAP package
          with custom overrides to enable modules or other
          functionality.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "openldap";
        description = lib.mdDoc "User account under which slapd runs.";
      };

      group = mkOption {
        type = types.str;
        default = "openldap";
        description = lib.mdDoc "Group account under which slapd runs.";
      };

      urlList = mkOption {
        type = types.listOf types.str;
        default = [ "ldap:///" ];
        description = lib.mdDoc "URL list slapd should listen on.";
        example = [ "ldaps:///" ];
      };

      settings = mkOption {
        type = ldapAttrsType;
        description = lib.mdDoc "Configuration for OpenLDAP, in OLC format";
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
                  olcDbDirectory = "/var/lib/openldap/ldap";
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
        description = lib.mdDoc ''
          Use this config directory instead of generating one from the
          `settings` option. Overrides all NixOS settings.
        '';
        example = "/var/lib/openldap/slapd.d";
      };

      mutableConfig = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to allow writable on-line configuration. If
          `true`, the NixOS settings will only be used to
          initialize the OpenLDAP configuration if it does not exist, and are
          subsequently ignored.
        '';
      };

      declarativeContents = mkOption {
        type = with types; attrsOf lines;
        default = {};
        description = lib.mdDoc ''
          Declarative contents for the LDAP database, in LDIF format by suffix.

          All data will be erased when starting the LDAP server. Modifications
          to the database are not prevented, they are just dropped on the next
          reboot of the server. Performance-wise the database and indexes are
          rebuilt on each server startup, so this will slow down server startup,
          especially with large databases.

          Note that the root of the DB must be defined in
          `services.openldap.settings` and the
          `olcDbDirectory` must begin with
          `"/var/lib/openldap"`.
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

  config = let
    dbSettings = mapAttrs' (name: { attrs, ... }: nameValuePair attrs.olcSuffix attrs)
      (filterAttrs (name: { attrs, ... }: (hasPrefix "olcDatabase=" name) && attrs ? olcSuffix) cfg.settings.children);
    settingsFile = pkgs.writeText "config.ldif" (lib.concatStringsSep "\n" (attrsToLdif "cn=config" cfg.settings));
    writeConfig = pkgs.writeShellScript "openldap-config" ''
      set -euo pipefail

      ${lib.optionalString (!cfg.mutableConfig) ''
        chmod -R u+w ${configDir}
        rm -rf ${configDir}/*
      ''}
      if [ ! -e "${configDir}/cn=config.ldif" ]; then
        ${openldap}/bin/slapadd -F ${configDir} -bcn=config -l ${settingsFile}
      fi
      chmod -R ${if cfg.mutableConfig then "u+rw" else "u+r-w"} ${configDir}
    '';

    contentsFiles = mapAttrs (dn: ldif: pkgs.writeText "${dn}.ldif" ldif) cfg.declarativeContents;
    writeContents = pkgs.writeShellScript "openldap-load" ''
      set -euo pipefail

      rm -rf $2/*
      ${openldap}/bin/slapadd -F ${configDir} -b $1 -l $3
    '';
  in mkIf cfg.enable {
    assertions = [{
      assertion = (cfg.declarativeContents != {}) -> cfg.configDir == null;
      message = ''
        Declarative DB contents (${attrNames cfg.declarativeContents}) are not
        supported with user-managed configuration.
      '';
    }] ++ (map (dn: {
      assertion = (getAttr dn dbSettings) ? "olcDbDirectory";
      # olcDbDirectory is necessary to prepopulate database using `slapadd`.
      message = ''
        Declarative DB ${dn} does not exist in `services.openldap.settings`, or does not have
        `olcDbDirectory` configured.
      '';
    }) (attrNames cfg.declarativeContents)) ++ (mapAttrsToList (dn: { olcDbDirectory ? null, ... }: {
      # For forward compatibility with `DynamicUser`, and to avoid accidentally clobbering
      # directories with `declarativeContents`.
      assertion = (olcDbDirectory != null) ->
      ((hasPrefix "/var/lib/openldap/" olcDbDirectory) && (olcDbDirectory != "/var/lib/openldap/"));
      message = ''
        Database ${dn} has `olcDbDirectory` (${olcDbDirectory}) that is not a subdirectory of
        `/var/lib/openldap/`.
      '';
    }) dbSettings);
    environment.systemPackages = [ openldap ];

    # Literal attributes must always be set
    services.openldap.settings = {
      attrs = {
        objectClass = "olcGlobal";
        cn = "config";
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
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStartPre = [
          "!${pkgs.coreutils}/bin/mkdir -p ${configDir}"
          "+${pkgs.coreutils}/bin/chown $USER ${configDir}"
        ] ++ (lib.optional (cfg.configDir == null) writeConfig)
        ++ (mapAttrsToList (dn: content: lib.escapeShellArgs [
          writeContents dn (getAttr dn dbSettings).olcDbDirectory content
        ]) contentsFiles)
        ++ [ "${openldap}/bin/slaptest -u -F ${configDir}" ];
        ExecStart = lib.escapeShellArgs ([
          "${openldap}/libexec/slapd" "-d" "0" "-F" configDir "-h" (lib.concatStringsSep " " cfg.urlList)
        ]);
        Type = "notify";
        # Fixes an error where openldap attempts to notify from a thread
        # outside the main process:
        #   Got notification message from PID 6378, but reception only permitted for main PID 6377
        NotifyAccess = "all";
        RuntimeDirectory = "openldap";
        StateDirectory = ["openldap"]
          ++ (map ({olcDbDirectory, ... }: removePrefix "/var/lib/" olcDbDirectory) (attrValues dbSettings));
        StateDirectoryMode = "700";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
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
