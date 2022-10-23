{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.rpki-client;
  tals = [
    "${cfg.package}/etc/rpki/afrinic.tal" "${cfg.package}/etc/rpki/apnic.tal"
    "${cfg.package}/etc/rpki/lacnic.tal" "${cfg.package}/etc/rpki/ripe.tal" ]
    ++ optional cfg.accept-arin-rpa "${pkgs.rpki-arin-tal}/arin.tal"
    ++ cfg.additional-tals;
in {
  options = {
    services.rpki-client = {
      enable = mkEnableOption (lib.mdDoc "Enable OpenBSD rpki-client");

      package = mkOption {
        description = lib.mdDoc "OpenBSD rpki-client";
        type = types.package;
        default = pkgs.rpki-client;
        defaultText = literalExpression "pkgs.rpki-client";
      };

      accept-arin-rpa = mkOption {
        description = lib.mdDoc "Accept the ARIN RPA and download the ARIN TAL";
        type = types.bool;
        default = false;
      };

      additional-tals = mkOption {
        description = lib.mdDoc "List of additional RFC7730 TAL files to be used";
        type = types.listOf types.str;
        default = [ ];
      };

      user = mkOption {
        type = types.str;
        default = "rpki-client";
        description = lib.mdDoc "User account under which rpki-client is started.";
      };

      group = mkOption {
        type = types.str;
        default = "rpki-client";
        description = lib.mdDoc "Group under which rpki-client is started.";
      };

      interval = mkOption {
        default = "1h";
        type = types.str;
        description = lib.mdDoc ''
          The interval at which to run rpki-client and update the lists.
          See {command}`man 7 systemd.time` for the format.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.rpki-client = {
      description = "OpenBSD rpki-client";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/rpki-client${concatMapStrings (x: " -t " + x) tals}";
        CacheDirectory = "rpki-client";
        StateDirectory = "rpki-client";
        PrivateDevices = "yes";
        PrivateTmp = "yes";
        ProtectClock = "yes";
        ProtectControlGroups = "yes";
        ProtectHome = "yes";
        ProtectHostname = "yes";
        ProtectKernelLogs = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        ProtectSystem = "strict";
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
        RestrictNamespaces = "yes";
        RestrictRealtime = "yes";
        RestrictSUIDSGID = "yes";
        LockPersonality = "yes";
        MemoryDenyWriteExecute = "yes";
        NoNewPrivileges = "yes";
        CapabilityBoundingSet = "";
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = "@system-service";
      };
    };

    systemd.timers.rpki-client = {
      description = "Run rpki-client";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = cfg.interval;
        OnUnitInactiveSec = cfg.interval;
      };
    };

    users = {
      users.rpki-client = mkIf (cfg.user == "rpki-client") {
        description = "OpenBSD rpki-client";
        group = cfg.group;
        isSystemUser = true;
      };
      groups.rpki-client = mkIf (cfg.group == "rpki-client") { };
    };
  };
}
