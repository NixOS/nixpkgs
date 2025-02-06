{
  config,
  lib,
  pkgs,
  ...
}:
{
  meta.maintainers = with lib.maintainers; [ arunoruto ];

  options.services.beszel-agent = {
    enable = lib.mkEnableOption "Enable the beszel agent service";
    package = lib.mkPackageOption pkgs "beszel" { };
    port = lib.mkOption {
      type = lib.types.port;
      default = 45876;
      description = "The port for the beszel agent service";
    };
    key = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "The raw value of the key";
    };
    keyFile = lib.mkOption {
      type = lib.types.path or lib.types.str;
      default = null;
      description = "The file location where the key for the beszel agent service is located";
    };
    extraFilesystems = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "The extra filesystems to be mounted";
    };
    gpu = lib.mkEnableOption "Enable GPU support";
    logLevel = lib.mkOption {
      type = lib.types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
      description = "The log level for the beszel agent service. Valid values are debug, info, warn, error.";
    };
  };

  config =
    let
      cfg = config.services.beszel-agent;
    in
    lib.mkIf cfg.enable {
      systemd = {
        services.beszel-agent = {
          # This ensures that nvidia-smi is in the path if GPU=true
          path = [ "/run/current-system/sw" ];
          unitConfig = {
            Description = "Beszel Agent Service";
            Wants = "network-online.target";
            After = "network-online.target";
          };
          serviceConfig = {
            Environment = lib.lists.map (x: ''"${x}"'') [
              "LOG_LEVEL=${cfg.logLevel}"
              "PORT=${builtins.toString cfg.port}"
              "KEY=${cfg.key}"
              "KEY_FILE=${cfg.keyFile}"
              "GPU=${if cfg.gpu then "true" else "false"}"
              "EXTRA_FILESYSTEMS=${lib.strings.concatStringsSep "," cfg.extraFilesystems}"
            ];
            ExecStart = "${cfg.package}/bin/beszel-agent";
            # User = "beszel";
            Restart = "on-failure";
            RestartSec = "5";
            StateDirectory = "beszel-agent";

            # Security/sandboxing settings
            KeyringMode = "private";
            LockPersonality = "yes";
            NoNewPrivileges = "yes";
            PrivateTmp = "yes";
            ProtectClock = "yes";
            ProtectHome = "read-only";
            ProtectHostname = "yes";
            ProtectKernelLogs = "yes";
            ProtectKernelTunables = "yes";
            ProtectSystem = "strict";
            RemoveIPC = "yes";
            RestrictSUIDSGID = "true";
            SystemCallArchitectures = "native";
          };
          wantedBy = [ "multi-user.target" ];
        };
      };
    };
}
