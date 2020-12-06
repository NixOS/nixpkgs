{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.powerdns;
  configDir = pkgs.writeTextDir "pdns.conf" "${cfg.extraConfig}";
in {
  options = {
    services.powerdns = {
      enable = mkEnableOption "PowerDNS domain name server";

      extraConfig = mkOption {
        type = types.lines;
        default = "launch=bind";
        description = ''
          PowerDNS configuration. Refer to
          <link xlink:href="https://doc.powerdns.com/authoritative/settings.html"/>
          for details on supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.packages = [ pkgs.powerdns ];

    systemd.services.pdns = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "mysql.service" "postgresql.service" "openldap.service" ];

      serviceConfig = {
        ExecStart = [ "" "${pkgs.powerdns}/bin/pdns_server --config-dir=${configDir} --guardian=no --daemon=no --disable-syslog --log-timestamp=no --write-pid=no" ];
      };
    };

    users.users.pdns = {
      isSystemUser = true;
      group = "pdns";
      description = "PowerDNS";
    };

    users.groups.pdns = {};

  };
}
