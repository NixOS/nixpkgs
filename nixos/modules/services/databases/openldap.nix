{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.openldap;
  openldap = pkgs.openldap;

  dataFile = pkgs.writeText "ldap-contents.ldif" cfg.declarativeContents;
  configFile = pkgs.writeText "slapd.conf" ((optionalString cfg.defaultSchemas ''
    include ${pkgs.openldap.out}/etc/schema/core.schema
    include ${pkgs.openldap.out}/etc/schema/cosine.schema
    include ${pkgs.openldap.out}/etc/schema/inetorgperson.schema
    include ${pkgs.openldap.out}/etc/schema/nis.schema
  '') + ''
    ${cfg.extraConfig}
    database ${cfg.database}
    suffix ${cfg.suffix}
    rootdn ${cfg.rootdn}
    ${if (cfg.rootpw != null) then ''
      rootpw ${cfg.rootpw}
    '' else ''
      include ${cfg.rootpwFile}
    ''}
    directory ${cfg.dataDir}
    ${cfg.extraDatabaseConfig}
  '');
  configOpts = if cfg.configDir == null then "-f ${configFile}"
               else "-F ${cfg.configDir}";
in

{

  ###### interface

  options = {

    services.openldap = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "
          Whether to enable the ldap server.
        ";
      };

      user = mkOption {
        type = types.string;
        default = "openldap";
        description = "User account under which slapd runs.";
      };

      group = mkOption {
        type = types.string;
        default = "openldap";
        description = "Group account under which slapd runs.";
      };

      urlList = mkOption {
        type = types.listOf types.string;
        default = [ "ldap:///" ];
        description = "URL list slapd should listen on.";
        example = [ "ldaps:///" ];
      };

      dataDir = mkOption {
        type = types.string;
        default = "/var/db/openldap";
        description = "The database directory.";
      };

      defaultSchemas = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Include the default schemas core, cosine, inetorgperson and nis.
          This setting will be ignored if configDir is set.
        '';
      };

      database = mkOption {
        type = types.str;
        default = "mdb";
        description = ''
          Database type to use for the LDAP.
          This setting will be ignored if configDir is set.
        '';
      };

      suffix = mkOption {
        type = types.str;
        example = "dc=example,dc=org";
        description = ''
          Specify the DN suffix of queries that will be passed to this backend
          database.
          This setting will be ignored if configDir is set.
        '';
      };

      rootdn = mkOption {
        type = types.str;
        example = "cn=admin,dc=example,dc=org";
        description = ''
          Specify the distinguished name that is not subject to access control
          or administrative limit restrictions for operations on this database.
          This setting will be ignored if configDir is set.
        '';
      };

      rootpw = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Password for the root user.
          This setting will be ignored if configDir is set.
          Using this option will store the root password in plain text in the
          world-readable nix store. To avoid this the <literal>rootpwFile</literal> can be used.
        '';
      };

      rootpwFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Password file for the root user.
          The file should contain the string <literal>rootpw</literal> followed by the password.
          e.g.: <literal>rootpw mysecurepassword</literal>
        '';
      };

      logLevel = mkOption {
        type = types.str;
        default = "0";
        example = "acl trace";
        description = "The log level selector of slapd.";
      };

      configDir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Use this optional config directory instead of using slapd.conf";
        example = "/var/db/slapd.d";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "
          slapd.conf configuration
        ";
        example = literalExample ''
            '''
            include ${pkgs.openldap.out}/etc/schema/core.schema
            include ${pkgs.openldap.out}/etc/schema/cosine.schema
            include ${pkgs.openldap.out}/etc/schema/inetorgperson.schema
            include ${pkgs.openldap.out}/etc/schema/nis.schema

            database bdb
            suffix dc=example,dc=org
            rootdn cn=admin,dc=example,dc=org
            # NOTE: change after first start
            rootpw secret
            directory /var/db/openldap
            '''
          '';
      };

      declarativeContents = mkOption {
        type = with types; nullOr lines;
        default = null;
        description = ''
          Declarative contents for the LDAP database, in LDIF format.

          Note a few facts when using it. First, the database
          <emphasis>must</emphasis> be stored in the directory defined by
          <code>dataDir</code>. Second, all <code>dataDir</code> will be erased
          when starting the LDAP server. Third, modifications to the database
          are not prevented, they are just dropped on the next reboot of the
          server. Finally, performance-wise the database and indexes are rebuilt
          on each server startup, so this will slow down server startup,
          especially with large databases.
        '';
        example = ''
          dn: dc=example,dc=org
          objectClass: domain
          dc: example

          dn: ou=users,dc=example,dc=org
          objectClass = organizationalUnit
          ou: users

          # ...
        '';
      };

      extraDatabaseConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          slapd.conf configuration after the database option.
          This setting will be ignored if configDir is set.
        '';
        example = ''
          # Indices to maintain for this directory
          # unique id so equality match only
          index uid eq
          # allows general searching on commonname, givenname and email
          index cn,gn,mail eq,sub
          # allows multiple variants on surname searching
          index sn eq,sub
          # sub above includes subintial,subany,subfinal
          # optimise department searches
          index ou eq
          # if searches will include objectClass uncomment following
          # index objectClass eq
          # shows use of default index parameter
          index default eq,sub
          # indices missing - uses default eq,sub
          index telephonenumber

          # other database parameters
          # read more in slapd.conf reference section
          cachesize 10000
          checkpoint 128 15
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.rootpwFile != null || cfg.rootpw != null;
        message = "Either services.openldap.rootpw or services.openldap.rootpwFile must be set";
      }
    ];

    environment.systemPackages = [ openldap ];

    systemd.services.openldap = {
      description = "LDAP server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        mkdir -p /run/slapd
        chown -R "${cfg.user}:${cfg.group}" /run/slapd
        ${optionalString (cfg.declarativeContents != null) ''
          rm -Rf "${cfg.dataDir}"
        ''}
        mkdir -p "${cfg.dataDir}"
        ${optionalString (cfg.declarativeContents != null) ''
          ${openldap.out}/bin/slapadd ${configOpts} -l ${dataFile}
        ''}
        chown -R "${cfg.user}:${cfg.group}" "${cfg.dataDir}"
      '';
      serviceConfig.ExecStart =
        "${openldap.out}/libexec/slapd -d '${cfg.logLevel}' " +
          "-u '${cfg.user}' -g '${cfg.group}' " +
          "-h '${concatStringsSep " " cfg.urlList}' " +
          "${configOpts}";
    };

    users.users.openldap =
      { name = cfg.user;
        group = cfg.group;
        uid = config.ids.uids.openldap;
      };

    users.groups.openldap =
      { name = cfg.group;
        gid = config.ids.gids.openldap;
      };

  };
}
