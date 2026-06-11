{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) submodule;
  inherit (lib.lists) optional;
  inherit (lib.meta) getExe;

  cfg = config.services.watt;

  format = pkgs.formats.toml { };
  cfgFile = format.generate "watt-config.toml" cfg.settings;
in
{
  options.services.watt = {
    enable = mkEnableOption "Automatic CPU speed & power optimizer for Linux";
    package = mkPackageOption pkgs "watt" { };

    settings = mkOption {
      default = { };
      type = submodule { freeformType = format.type; };
      description = "Configuration for Watt.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # According the the upstream package, this is necessary for the Watt CLI. The environment variable
    # passed to the systemd service will take priority in read order.
    environment.etc."watt.toml".source = cfgFile;

    services.dbus.packages = [ cfg.package ];

    systemd.services.watt = {
      wantedBy = [ "multi-user.target" ];
      conflicts = [
        "auto-cpufreq.service"
        "power-profiles-daemon.service"
        "tlp.service"
        "cpupower-gui.service"
        "thermald.service"
      ];
      serviceConfig = {
        Environment = optional (cfg.settings != { }) [ "WATT_CONFIG=${cfgFile}" ];
        WorkingDirectory = "";
        ExecStart = getExe cfg.package;
        Restart = "on-failure";

        RuntimeDirectory = "watt";
        RuntimeDirectoryMode = "0755";
      };
    };

    assertions = [
      {
        assertion = !config.services.power-profiles-daemon.enable;
        message = ''
          You have set services.power-profiles-daemon.enable = true;
          which conflicts with Watt.
        '';
      }
      {
        assertion = !config.services.auto-cpufreq.enable;
        message = ''
          You have set services.auto-cpufreq.enable = true;
          which conflicts with Watt.
        '';
      }
      {
        assertion = !config.services.tlp.enable;
        message = ''
          You have set services.tlp.enable = true;
          which conflicts with Watt.
        '';
      }
      {
        assertion = !config.services.cpupower-gui.enable;
        message = ''
          You have set services.cpupower-gui.enable = true;
          which conflicts with Watt.
        '';
      }
      {
        assertion = !config.services.thermald.enable;
        message = ''
          You have set services.thermald.enable = true;
          which conflicts with Watt.
        '';
      }
    ];
  };
}
