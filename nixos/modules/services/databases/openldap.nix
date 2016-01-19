{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.openldap;
  openldap = pkgs.openldap;

  configFile = pkgs.writeText "slapd.conf" cfg.extraConfig;

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
        example = true;
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

      dataDir = mkOption {
        type = types.string;
        default = "/var/db/openldap";
        description = "The database directory.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "
          sldapd.conf configuration
        ";
        example = ''
            include ''${pkgs.openldap}/etc/openldap/schema/core.schema
            include ''${pkgs.openldap}/etc/openldap/schema/cosine.schema
            include ''${pkgs.openldap}/etc/openldap/schema/inetorgperson.schema
            include ''${pkgs.openldap}/etc/openldap/schema/nis.schema

            database bdb 
            suffix dc=example,dc=org 
            rootdn cn=admin,dc=example,dc=org 
            # NOTE: change after first start
            rootpw secret
            directory /var/db/openldap
          '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.openldap.enable {

    environment.systemPackages = [ openldap ];

    systemd.services.openldap = {
      description = "LDAP server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        mkdir -p /var/run/slapd
        chown -R ${cfg.user}:${cfg.group} /var/run/slapd
        mkdir -p ${cfg.dataDir}
        chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
      '';
      serviceConfig.ExecStart = "${openldap.out}/libexec/slapd -u ${cfg.user} -g ${cfg.group} -d 0 -f ${configFile}";
    };

    users.extraUsers.openldap =
      { name = cfg.user;
        group = cfg.group;
        uid = config.ids.uids.openldap;
      };

    users.extraGroups.openldap =
      { name = cfg.group;
        gid = config.ids.gids.openldap;
      };

  };
}
