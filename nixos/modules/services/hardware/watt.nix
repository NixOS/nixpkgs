{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    getExe
    ;
  inherit (lib.types) submodule;

  cfg = config.services.watt;

  format = pkgs.formats.toml { };
  cfgFile = format.generate "watt-config.toml" cfg.settings;

  conflictingServices = [
    "power-profiles-daemon"
    "auto-cpufreq"
    "tlp"
    "cpupower-gui"
    "thermald"
  ];

in
{
  options.services.watt = {
    enable = mkEnableOption "automatic CPU speed & power optimizer for Linux";
    package = mkPackageOption pkgs "watt" { };

    settings = mkOption {
      default = { };
      type = submodule { freeformType = format.type; };
      description = "Configuration for Watt. Options at https://github.com/notaShelf/watt";
    };
  };

  config = mkIf cfg.enable {
    assertions = map (service: {
      assertion = !config.services.${service}.enable;
      message = "You have set services.${service}.enable = true; which conflicts with Watt.";
    }) conflictingServices;

    environment.systemPackages = [ cfg.package ];

    # This is necessary for the Watt CLI. The environment variable
    # passed to the systemd service will take priority in read order.
    environment.etc."watt.toml".source = cfgFile;

    services.dbus.packages = [ cfg.package ];

    systemd.services.watt = {
      wantedBy = [ "multi-user.target" ];
      conflicts = map (service: "${service}.service") conflictingServices;
      serviceConfig = {
        WorkingDirectory = "";
        ExecStart = getExe cfg.package;
        Restart = "on-failure";

        RuntimeDirectory = "watt";
        RuntimeDirectoryMode = "0755";
      };
    };

  };
}
