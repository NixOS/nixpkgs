{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;
  inherit (lib.types) str;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.hardware.antec;
in
{
  meta.maintainers = [ lib.maintainers.kruziikrel13 ];

  options = {
    hardware.antec = {
      enable = mkEnableOption "support for Antec Flux Pro GPU and CPU Temperature Sensor.";
      cpu-device = mkOption {
        type = str;
        default = "k10temp";
        description = "CPU temperature device name";
      };
      cpu-temp-type = mkOption {
        type = str;
        default = "tctl";
        description = "CPU temperature sensor label";
      };
      gpu-device = mkOption {
        type = str;
        default = "amdgpu";
        description = "GPU temperature device name";
      };
      gpu-temp-type = mkOption {
        type = str;
        default = "edge";
        description = "GPU temperature sensor label";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.antec-flux-pro ];
    services.udev.packages = [ pkgs.antec-flux-pro.udev ];
    environment.etc."antec-flux-pro-display/config.conf".text = ''
      cpu_device=${cfg.cpu-device}
      cpu_temp_type=${cfg.cpu-temp-type}
      gpu_device=${cfg.gpu-device}
      gpu_temp_type=${cfg.gpu-temp-type}
      update_interval=1000
    '';

    systemd.services.antec-flux-pro-display = {
      unitConfig = {
        Description = "Service for monitoring and displaying Antec Flux Pro case temperature sensors.";
        StartLimitIntervalSec = "0";
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = getExe pkgs.antec-flux-pro;
        Restart = "always";
        RestartSec = "5";
        ProtectSystem = "strict";
        ProtectHome = "true";
        PrivateTmp = "true";
        NoNewPrivileges = "true";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };

}
