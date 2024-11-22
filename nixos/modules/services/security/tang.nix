{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.tang;
in
{
  options.services.tang = {
    enable = mkEnableOption "tang";

    package = mkOption {
      type = types.package;
      default = pkgs.tang;
      defaultText = literalExpression "pkgs.tang";
      description = "The tang package to use.";
    };

    listenStream = mkOption {
      type = with types; listOf str;
      default = [ "7654" ];
      example = [ "198.168.100.1:7654" "[2001:db8::1]:7654" "7654" ];
      description = ''
        Addresses and/or ports on which tang should listen.
        For detailed syntax see ListenStream in {manpage}`systemd.socket(5)`.
      '';
    };

    ipAddressAllow = mkOption {
      example = [ "192.168.1.0/24" ];
      type = types.listOf types.str;
      description = ''
        Whitelist a list of address prefixes.
        Preferably, internal addresses should be used.
      '';
    };

  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services."tangd@" = {
      description = "Tang server";
      path = [ cfg.package ];
      serviceConfig = {
        StandardInput = "socket";
        StandardOutput = "socket";
        StandardError = "journal";
        DynamicUser = true;
        StateDirectory = "tang";
        RuntimeDirectory = "tang";
        StateDirectoryMode = "700";
        UMask = "0077";
        CapabilityBoundingSet = [ "" ];
        ExecStart = "${cfg.package}/libexec/tangd %S/tang";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        DeviceAllow = [ "/dev/stdin" ];
        RestrictAddressFamilies = [ "AF_UNIX" ];
        DevicePolicy = "strict";
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
        IPAddressDeny = "any";
        IPAddressAllow = cfg.ipAddressAllow;
      };
    };

    systemd.sockets.tangd = {
      description = "Tang server";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = cfg.listenStream;
        Accept = "yes";
        IPAddressDeny = "any";
        IPAddressAllow = cfg.ipAddressAllow;
      };
    };
  };
  meta.maintainers = with lib.maintainers; [ jfroche julienmalka ];
}
