{ config, pkgs, ... }:

with pkgs.lib;

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
      '';
      serviceConfig.ExecStart = "${openldap}/libexec/slapd -d 0 -f ${configFile}";
    };

  };

}
