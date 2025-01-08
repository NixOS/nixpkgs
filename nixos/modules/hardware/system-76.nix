{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.hardware.system76;
  opt = options.hardware.system76;

  kpkgs = config.boot.kernelPackages;
  modules = [
    "system76"
    "system76-io"
  ] ++ (lib.optional (lib.versionOlder kpkgs.kernel.version "5.5") "system76-acpi");
  modulePackages = map (m: kpkgs.${m}) modules;
  moduleConfig = lib.mkIf cfg.kernel-modules.enable {
    boot.extraModulePackages = modulePackages;

    boot.kernelModules = modules;

    services.udev.packages = modulePackages;
  };

  firmware-pkg = pkgs.system76-firmware;
  firmwareConfig = lib.mkIf cfg.firmware-daemon.enable {
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
  powerConfig = lib.mkIf cfg.power-daemon.enable {
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
      enableAll = lib.mkEnableOption "all recommended configuration for system76 systems";

      firmware-daemon.enable = lib.mkOption {
        default = cfg.enableAll;
        defaultText = lib.literalExpression "config.${opt.enableAll}";
        example = true;
        description = "Whether to enable the system76 firmware daemon";
        type = lib.types.bool;
      };

      kernel-modules.enable = lib.mkOption {
        default = cfg.enableAll;
        defaultText = lib.literalExpression "config.${opt.enableAll}";
        example = true;
        description = "Whether to make the system76 out-of-tree kernel modules available";
        type = lib.types.bool;
      };

      power-daemon.enable = lib.mkOption {
        default = cfg.enableAll;
        defaultText = lib.literalExpression "config.${opt.enableAll}";
        example = true;
        description = "Whether to enable the system76 power daemon";
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkMerge [
    moduleConfig
    firmwareConfig
    powerConfig
  ];
}
