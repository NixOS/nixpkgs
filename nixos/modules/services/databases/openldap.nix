{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.openldap;
  openldap = pkgs.openldap;

  dataFile = pkgs.writeText "ldap-contents.ldif" cfg.declarativeContents;
  configFile = pkgs.writeText "slapd.conf" cfg.extraConfig;
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
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ openldap ];

    systemd.services.openldap = {
      description = "LDAP server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        mkdir -p /var/run/slapd
        chown -R "${cfg.user}:${cfg.group}" /var/run/slapd
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
        "${openldap.out}/libexec/slapd -d ${cfg.logLevel} " +
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
