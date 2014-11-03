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
        default = false;
        description = "
          Whether to enable the ldap server.
        ";
      };

      user = mkOption {
        default = "openldap";
        description = "User account under which slapd runs.";
      };

      group = mkOption {
        default = "openldap";
        description = "Group account under which slapd runs.";
      };

      extraConfig = mkOption {
        default = "";
        description = "
          sldapd.conf configuration
        ";
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
        mkdir -p /var/db/openldap
        chown -R ${cfg.user}:${cfg.group} /var/db/openldap
      '';
      serviceConfig.ExecStart = "${openldap}/libexec/slapd -u openldap -g openldap -d 0 -f ${configFile}";
    };

    users.extraUsers = optionalAttrs (cfg.user == "openldap") (singleton
      { name = "openldap";
        group = cfg.group;
        uid = config.ids.uids.openldap;
      });

    users.extraGroups = optionalAttrs (cfg.group == "openldap") (singleton
      { name = "openldap";
        gid = config.ids.gids.openldap;
     });

  };
}
