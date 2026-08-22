{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;
  inherit (lib.types) int str submodule;
  inherit (lib.options) mkEnableOption mkOption mkPackageOption;
  toConf = lib.generators.toKeyValue { };

  cfg = config.hardware.antec-flux-pro-display;
in
{
  meta.maintainers = [ lib.maintainers.kruziikrel13 ];

  options.hardware.antec-flux-pro-display = {
    enable = mkEnableOption "support for Antec Flux Pro GPU and CPU Temperature Sensor.";
    package = mkPackageOption pkgs "antec-flux-pro-display";
    settings = mkOption {
      description = "Settings written to /etc/antec-flux-pro-display/config.conf";
      type = submodule {
        options = {
          cpu_device = mkOption {
            type = str;
            description = "CPU temperature device name.";
            example = "k10temp";
          };
          cpu_temp_type = mkOption {
            type = str;
            description = "CPU temperature sensor label.";
            example = "tctl";
          };
          gpu_device = mkOption {
            type = str;
            description = "GPU temperature device name.";
            example = "amdgpu";
          };
          gpu_temp_type = mkOption {
            type = str;
            description = "GPU temperature sensor label.";
            example = "edge";
          };
          update_interval = mkOption {
            type = int;
            description = "Update interval in milliseconds.";
            default = 1000;
          };
        };
      };
      default = { };
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
    environment.etc."antec-flux-pro-display/config.conf".text = toConf cfg.settings;

    systemd.services.antec-flux-pro-display = {
      description = "Antec Flux Pro Display Service";
      serviceConfig = {
        Type = "simple";
        ExecStart = getExe cfg.package;
        Restart = "always";
        RestartSec = 5;
        ProtectSystem = "strict";
        ProtectHome = "true";
        PrivateTmp = "true";
        NoNewPrivileges = "true";
      };
      restartTriggers = [ config.environment."antec-flux-pro-display/config.conf".source ];
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udevd.service" ];
    };
  };
}
