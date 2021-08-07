{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.adguardhome;

  args = concatStringsSep " " ([
    "--no-check-update"
    "--pidfile /run/AdGuardHome/AdGuardHome.pid"
    "--work-dir /var/lib/AdGuardHome/"
    "--config /var/lib/AdGuardHome/AdGuardHome.yaml"
    "--host ${cfg.host}"
    "--port ${toString cfg.port}"
  ] ++ cfg.extraArgs);

in
{
  options.services.adguardhome = with types; {
    enable = mkEnableOption "AdGuard Home network-wide ad blocker";

    host = mkOption {
      default = "0.0.0.0";
      type = str;
      description = ''
        Host address to bind HTTP server to.
      '';
    };

    port = mkOption {
      default = 3000;
      type = port;
      description = ''
        Port to serve HTTP pages on.
      '';
    };

    openFirewall = mkOption {
      default = false;
      type = bool;
      description = ''
        Open ports in the firewall for the AdGuard Home web interface. Does not
        open the port needed to access the DNS resolver.
      '';
    };

    extraArgs = mkOption {
      default = [ ];
      type = listOf str;
      description = ''
        Extra command line parameters to be passed to the adguardhome binary.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.adguardhome = {
      description = "AdGuard Home: Network-level blocker";
      after = [ "syslog.target" "network.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        StartLimitIntervalSec = 5;
        StartLimitBurst = 10;
      };
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.adguardhome}/bin/adguardhome ${args}";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        Restart = "always";
        RestartSec = 10;
        RuntimeDirectory = "AdGuardHome";
        StateDirectory = "AdGuardHome";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };
}
