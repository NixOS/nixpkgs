{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption types mkIf mkMerge optional versionOlder;
  cfg = config.hardware.system76;

  kpkgs = config.boot.kernelPackages;
  modules = [ "system76" "system76-io" ] ++ (optional (versionOlder kpkgs.kernel.version "5.5") "system76-acpi");
  modulePackages = map (m: kpkgs.${m}) modules;
  moduleConfig = mkIf cfg.kernel-modules.enable {
    boot.extraModulePackages = modulePackages;

    boot.kernelModules = modules;

    services.udev.packages = modulePackages;
  };

  firmware-pkg = pkgs.system76-firmware;
  firmwareConfig = mkIf cfg.firmware-daemon.enable {
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
in {
  options = {
    hardware.system76 = {
      enableAll = mkEnableOption "all recommended configuration for system76 systems";

      firmware-daemon.enable = mkOption {
        default = cfg.enableAll;
        example = true;
        description = "Whether to enable the system76 firmware daemon";
        type = types.bool;
      };

      kernel-modules.enable = mkOption {
        default = cfg.enableAll;
        example = true;
        description = "Whether to make the system76 out-of-tree kernel modules available";
        type = types.bool;
      };
    };
  };

  config = mkMerge [ moduleConfig firmwareConfig ];
}
