{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cloudflared-dns;
  listenAddressParts = splitString ":" cfg.listenAddress;
  opts = assert (builtins.length listenAddressParts) == 2;
    [
      "--metrics ${cfg.metricsAddress}"
      "--max-upstream-conns ${toString cfg.maxUpstreamConnections}"
      (concatStringsSep " " (map (ep: "--upstream ${toString ep}") cfg.upstreamEndpoints))
      (concatStringsSep " " (map (ep: "--bootstrap ${toString ep}") cfg.bootstrapEndpoints))
      "--address ${builtins.elemAt listenAddressParts 0}"
      "--port ${builtins.elemAt listenAddressParts 1}"
    ];
  cmdline = "${cfg.package}/bin/cloudflared proxy-dns ${concatStringsSep " " opts}";
in

{
  meta.maintainers = with lib.maintainers; [ ckie ];

  options.services.cloudflared-dns = {
    enable = mkEnableOption "Enables the cloudflared DNS-over-HTTPS proxying daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.cloudflared;
      description = "The cloudflared package to use.";
    };

    metricsAddress = mkOption {
      type = types.str;
      default = "localhost:43759";
      description = "Listen address for metrics reporting.";
    };

    listenAddress = mkOption {
      type = types.str;
      default = "localhost:53";
      description = "Listen address for inbound traffic.";
    };

    maxUpstreamConnections = mkOption {
      type = types.int;
      default = 5;
      description = "Maximum concurrent connections to upstream.";
    };

    upstreamEndpoints = mkOption {
      type = types.listOf types.str;
      default = [
        "https://1.1.1.1/dns-query"
        "https://1.0.0.1/dns-query"
      ];
      description = "Upstream endpoint URLs";
    };

    bootstrapEndpoints = mkOption {
      type = types.listOf types.str;
      default = [
        "https://162.159.36.1/dns-query"
        "https://162.159.46.1/dns-query"
        "https://[2606:4700:4700::1111]/dns-query"
        "https://[2606:4700:4700::1001]/dns-query"
      ];
      description = "Bootstrap endpoint URLs";
    };

  };

  config = mkIf cfg.enable {
    systemd.services.cloudflared-dns = {
      description = "cloudflared DNS-over-HTTPS proxying daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];

      serviceConfig =
        {
          ExecStart = cmdline;
          Restart = "always";
          DynamicUser = true;

          PrivateTmp = true;
          ProtectHome = true;
          ProtectSystem = "full";
          DevicePolicy = "closed";
          NoNewPrivileges = true;
          CapabilityBoundingSet = "";
          DeviceAllow = [ ];
          ProtectControlGroups = true;
          ProtectClock = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RemoveIPC = true;
          ProtectProc = "invisible";
          RestrictAddressFamilies = [ "~AF_UNIX" "~AF_NETLINK" ];
          RestrictSUIDSGID = true;
          RestrictRealtime = true;
          LockPersonality = true;
          SystemCallArchitectures = "native";
          ProcSubset = "pid";
          SystemCallFilter = [
            "~@reboot"
            "~@module"
            "~@mount"
            "~@swap"
            "~@resources"
            "~@cpu-emulation"
            "~@obsolete"
            "~@debug"
            "~@privileged"
          ];
        };
    };
  };
}
