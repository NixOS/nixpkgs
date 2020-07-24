{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.powerdns;
  configDir = pkgs.writeTextDir "pdns.conf" "${cfg.extraConfig}";
in {
  options = {
    services.powerdns = {
      enable = mkEnableOption "Powerdns domain name server";

      extraConfig = mkOption {
        type = types.lines;
        default = "launch=bind";
        description = ''
          Extra lines to be added verbatim to pdns.conf.
          Powerdns will chroot to /var/lib/powerdns.
          So any file, powerdns is supposed to be read,
          should be in /var/lib/powerdns and needs to specified
          relative to the chroot.
        '';
      };
    };
  };

  config = mkIf config.services.powerdns.enable {
    systemd.services.pdns = {
      unitConfig.Documentation = "man:pdns_server(1) man:pdns_control(1)";
      description = "Powerdns name server";
      wantedBy = [ "multi-user.target" ];
      after = ["network.target" "mysql.service" "postgresql.service" "openldap.service"];

      serviceConfig = {
        Restart="on-failure";
        RestartSec="1";
        StartLimitInterval="0";
        PrivateDevices=true;
        CapabilityBoundingSet="CAP_CHOWN CAP_NET_BIND_SERVICE CAP_SETGID CAP_SETUID CAP_SYS_CHROOT";
        NoNewPrivileges=true;
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/lib/powerdns";
        ExecStart = "${pkgs.powerdns}/bin/pdns_server --setuid=nobody --setgid=nogroup --chroot=/var/lib/powerdns --socket-dir=/ --daemon=no --guardian=no --disable-syslog --write-pid=no --config-dir=${configDir}";
        ProtectSystem="full";
        ProtectHome=true;
        RestrictAddressFamilies="AF_UNIX AF_INET AF_INET6";
      };
    };
  };
}
