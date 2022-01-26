{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.opentracker;
in {
  options.services.opentracker = {
    enable = mkEnableOption (lib.mdDoc "opentracker");

    package = mkOption {
      type = types.package;
      description = lib.mdDoc ''
        opentracker package to use
      '';
      default = pkgs.opentracker;
      defaultText = literalExpression "pkgs.opentracker";
    };

    extraOptions = mkOption {
      type = types.separatedString " ";
      description = lib.mdDoc ''
        Configuration Arguments for opentracker
        See https://erdgeist.org/arts/software/opentracker/ for all params
      '';
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.opentracker = {
      description = "opentracker server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartIfChanged = true;
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/opentracker ${cfg.extraOptions}";
        PrivateTmp = true;
        WorkingDirectory = "/var/empty";
        # By default opentracker drops all privileges and runs in chroot after starting up as root.

        CapabilityBoundingSet = "CAP_SYS_CHROOT CAP_SETUID CAP_SETGID";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };
  };
}

