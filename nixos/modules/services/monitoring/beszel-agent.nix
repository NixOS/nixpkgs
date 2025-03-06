{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.beszel.agent;
in
{
  meta.maintainers = with lib.maintainers; [
    BonusPlay
    arunoruto
  ];

  options.services.beszel.agent = {
    enable = lib.mkEnableOption "beszel agent";

    package = lib.mkPackageOption pkgs "beszel" { };

    environment = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Environment variables for configuring the beszel-agent service.
        This field will end up public in /nix/store, for secret values use `environmentFile`.
      '';
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File path containing environment variables for configuring the beszel-agent service in the format of an EnvironmentFile. See {manpage}`systemd.exec(5)`.
      '';
    };
    extraPath = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Extra packages to add to beszel path (such as nvidia-smi or rocm-smi).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.beszel-agent = {
      description = "Beszel Agent";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment = cfg.environment;
      path = cfg.extraPath;

      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/beszel-agent
        '';

        EnvironmentFile = cfg.environmentFile;

        DynamicUser = true;
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        Restart = "on-failure";
        RestartSec = "30s";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" ];
        Type = "simple";
        UMask = 27;
      };
    };
  };
}
