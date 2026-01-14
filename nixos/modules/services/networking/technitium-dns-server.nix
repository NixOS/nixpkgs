{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.technitium-dns-server;
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    types
    ;
in
{
  options.services.technitium-dns-server = {
    enable = mkEnableOption "Technitium DNS Server";

    package = mkPackageOption pkgs "technitium-dns-server" { };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open ports in the firewall.
        Standard ports are 53 (UDP and TCP, for DNS), 5380 and 53443 (TCP, HTTP and HTTPS for web interface).
        Specify different or additional ports in options firewallUDPPorts and firewallTCPPorts if necessary.
      '';
    };

    firewallUDPPorts = mkOption {
      type = with types; listOf int;
      default = [ 53 ];
      description = ''
        List of UDP ports to open in firewall.
      '';
    };

    firewallTCPPorts = mkOption {
      type = with types; listOf int;
      default = [
        53
        5380 # web interface HTTP
        53443 # web interface HTTPS
      ];
      description = ''
        List of TCP ports to open in firewall.
        You might want to open ports 443 and 853 if you intend to use DNS over HTTPS or DNS over TLS.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.technitium-dns-server = {
      description = "Technitium DNS Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/technitium-dns-server $STATE_DIRECTORY";

        DynamicUser = true;

        StateDirectory = "technitium-dns-server";

        Restart = "always";
        RestartSec = 10;
        TimeoutStopSec = 10;
        KillSignal = "SIGINT";

        # Harden the service
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = cfg.firewallUDPPorts;
      allowedTCPPorts = cfg.firewallTCPPorts;
    };
  };

  meta.maintainers = with lib.maintainers; [ fabianrig ];
}
