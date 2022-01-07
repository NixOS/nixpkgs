{ config, lib, pkgs, ... }:
with lib;

let cfg = config.services.adguard-dnsproxy;

in {
  meta.maintainers = with lib.maintainers; [ ckie ];
  options.services.adguard-dnsproxy = {
    enable = mkEnableOption
      "dnsproxy, a simple DNS proxy with DoH, DoT, DoQ and DNSCrypt support.";
    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra arguments to pass to dnsproxy.";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.dnsproxy;
      defaultText = literalExpression "pkgs.dnsproxy";
      description = "The package containing the dnsproxy binary.";
    };
    port = mkOption {
      type = types.nullOr types.port;
      default = null;
      description = "An optional port to listen on for raw DNS traffic.";
    };
    upstreams = mkOption {
      type = types.listOf types.str;
      default = null;
      description = "Upstream servers to talk with.";
    };
    fallbacks = mkOption {
      type = types.listOf types.str;
      default = [ "1.1.1.1" "9.9.9.9" "8.8.8.8" ];
      description =
        "Fallback upstream servers to talk with, used for bootstrapping the connection to the primary upstreams.";
    };
    verbose = mkOption {
      type = types.bool;
      default = false;
      description = "Enable verbose debugging output.";
    };
  };

  config = mkIf cfg.enable {
    services.adguard-dnsproxy.extraOptions = [ ]
      ++ optional (cfg.port != null) "--port ${toString cfg.port}"
      ++ map (u: "--upstream ${escapeShellArg u}") cfg.upstreams
      ++ map (u: "--fallback ${escapeShellArg u}") cfg.fallbacks
      ++ optional cfg.verbose "--verbose";

    systemd.services.adguard-dnsproxy = {
      description = "adguard-dnsproxy";
      wants = [ "network-online.target" "nss-lookup.target" ];
      before = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CacheDirectory = "adguard-dnsproxy";
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/dnsproxy ${
            concatStringsSep " " cfg.extraOptions
          }";
        LockPersonality = true;
        LogsDirectory = "adguard-dnsproxy";
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        NonBlocking = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        Restart = "always";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RuntimeDirectory = "adguard-dnsproxy";
        StateDirectory = "adguard-dnsproxy";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@chown"
          "~@aio"
          "~@keyring"
          "~@memlock"
          "~@resources"
          "~@setuid"
          "~@timer"
        ];
      };
    };
  };
}
