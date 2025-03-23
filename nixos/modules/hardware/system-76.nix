{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkOption
    mkEnableOption
    types
    mkIf
    mkMerge
    optional
    versionOlder
    ;
  cfg = config.hardware.system76;
  opt = options.hardware.system76;

  kpkgs = config.boot.kernelPackages;
  modules = [
    "system76"
    "system76-io"
  ] ++ (optional (versionOlder kpkgs.kernel.version "5.5") "system76-acpi");
  modulePackages = map (m: kpkgs.${m}) modules;
  moduleConfig = mkIf cfg.kernel-modules.enable {
    boot.extraModulePackages = modulePackages;

    boot.kernelModules = modules;

    services.udev.packages = modulePackages;
  };

  firmware-pkg = pkgs.system76-firmware;
  firmwareConfig = mkIf cfg.firmware-daemon.enable {
    # Make system76-firmware-cli usable by root from the command line.
    environment.systemPackages = [ firmware-pkg ];

    services.dbus.packages = [ firmware-pkg ];

    systemd.services.system76-firmware-daemon = {
      description = "The System76 Firmware Daemon";

      serviceConfig = {
        ExecStart = "${firmware-pkg}/bin/system76-firmware-daemon";

        Restart = "on-failure";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };

  power-pkg = pkgs.system76-power;
  powerConfig = mkIf cfg.power-daemon.enable {
    # Make system76-power usable by root from the command line.
    environment.systemPackages = [ power-pkg ];

    services.dbus.packages = [ power-pkg ];

    systemd.services.system76-power = {
      description = "System76 Power Daemon";
      serviceConfig = {
        ExecStart = "${power-pkg}/bin/system76-power daemon";
        Restart = "on-failure";
        Type = "dbus";
        BusName = "com.system76.PowerDaemon";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
in
{
  options = {
    hardware.system76 = {
      enableAll = mkEnableOption "all recommended configuration for system76 systems";

      firmware-daemon.enable = mkOption {
        default = cfg.enableAll;
        defaultText = literalExpression "config.${opt.enableAll}";
        example = true;
        description = "Whether to enable the system76 firmware daemon";
        type = types.bool;
      };

      kernel-modules.enable = mkOption {
        default = cfg.enableAll;
        defaultText = literalExpression "config.${opt.enableAll}";
        example = true;
        description = "Whether to make the system76 out-of-tree kernel modules available";
        type = types.bool;
      };

      power-daemon.enable = mkOption {
        default = cfg.enableAll;
        defaultText = literalExpression "config.${opt.enableAll}";
        example = true;
        description = "Whether to enable the system76 power daemon";
        type = types.bool;
      };
    };
  };

  config = mkMerge [
    moduleConfig
    firmwareConfig
    powerConfig
  ];
}
