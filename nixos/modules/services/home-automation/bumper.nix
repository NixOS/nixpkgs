{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    maintainers
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.services.bumper;

  stateDir = "/var/lib/bumper";
in
{
  meta.maintainers = with maintainers; [ ananthb ];

  options.services.bumper = {
    enable = mkEnableOption "bumper, a server for Ecovacs vacuum robots";

    package = lib.mkPackageOption pkgs "bumper" { };

    logLevel = mkOption {
      type = types.enum [ "DEBUG" "INFO" "WARNING" "ERROR" "CRITICAL" ];
      default = "INFO";
      description = "Set logging level for bumper.";
    };

    verboseLogging = mkOption {
      type = types.nullOr (types.ints.between 1 2);
      default = null;
      description = "Enable verbose logging for bumper application. Value indicates verbosity level.";
    };

    address = mkOption {
      type = types.str;
      default = "[::]";
      description = "Bumper listens on this address. It listens on all interfaces by default.";
    };

    announceIP = mkOption {
      type = types.str;
      default = "auto";
      description = "IP address to announce to robots (default: auto-detect)";
    };

    mqttTLSPort = mkOption {
      type = types.port;
      default = 6052;
      description = "MQTT TLS server port";
    };

    mqttport = mkOption {
      type = types.port;
      default = 6052;
      description = "MQTT plaintext server port";
    };

    httpTLSPort = mkOption {
      type = types.port;
      default = 6053;
      description = "HTTP TLS server port";
    };

    httpPort = mkOption {
      type = types.port;
      default = 6053;
      description = "HTTP plaintext server port";
    };

    xmppTLSPort = mkOption {
      type = types.port;
      default = 6054;
      description = "XMPP TLS server port";
    };

    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open the firewall for bumper application ports.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [
      cfg.mqttport
      cfg.mqttTLSPort
      cfg.httpPort
      cfg.httpTLSPort
      cfg.xmppTLSPort
    ];

    systemd.services.bumper = {
      description = "Bumper Robot Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/bumper";
        DynamicUser = true;
        User = "bumper";
        Group = "bumper";
        WorkingDirectory = stateDir;
        StateDirectory = "bumper";
        StateDirectoryMode = "0750";
        Restart = "on-failure";

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        DevicePolicy = "closed";
        #NoNewPrivileges = true; # Implied by DynamicUser
        PrivateUsers = true;
        #PrivateTmp = true; # Implied by DynamicUser
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid cgroup net";
        ProtectSystem = "strict";
        #RemoveIPC = true; # Implied by DynamicUser
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        #RestrictSUIDSGID = true; # Implied by DynamicUser
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
        ];
        UMask = "0077";
      };
    };
  };
}
