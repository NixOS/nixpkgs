{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.technitium-dns-server;
  stateDir = "/var/lib/technitium-dns-server";
in
{
  options.services.technitium-dns-server = {
    enable = mkEnableOption "Technitium DNS Server";

    package = mkPackageOption pkgs "technitium-dns-server" { };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Whether to open ports in the firewall.
        Standard ports are 53 (UDP and TCP, for DNS), 5380 and 53443 (TCP, HTTP and HTTPS for web interface).
        Specify different or additional ports in options firewallUDPPorts and firewallTCPPorts if necessary.
      '';
    };

    firewallUDPPorts = mkOption {
      type = with types; listOf int;
      default = [ 53 ];
      description = mdDoc ''
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
      description = mdDoc ''
        List of TCP ports to open in firewall.
        You might want to open ports 443 and 853 if you intend to use DNS over HTTPS or DNS over TLS.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "technitiumdns";
      description = mdDoc ''
        User to run Technitium DNS server and owner of the state directory.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "technitiumdns";
      description = mdDoc ''
        The Technitium DNS user's group.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.technitium-dns-server = {
      description = "Technitium DNS Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/technitium-dns-server ${stateDir}";

        User = cfg.user;
        Group = cfg.group;

        StateDirectory = "technitium-dns-server";
        WorkingDirectory = stateDir;
        BindPaths = stateDir;

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

    users.users = mkIf (cfg.user == "technitiumdns") {
      technitiumdns = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "technitiumdns") { technitiumdns = { }; };
  };

  meta.maintainers = with lib.maintainers; [ fabianrig ];
}
