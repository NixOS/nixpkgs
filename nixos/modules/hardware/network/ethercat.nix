{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.hardware.ethercat;

  macAddress = lib.types.strMatching "^([0-9A-Fa-f]{2}:){5}([0-9A-Fa-f]{2})$";

  master = lib.types.submodule {
    options = {
      primary = lib.mkOption {
        description = "MAC address of an network interface to use for the EtherCAT master.";
        type = macAddress;
      };
      backup = lib.mkOption {
        description = "MAC address of an network interface to use as a backup for the EtherCAT master.";
        type = lib.types.nullOr macAddress;
      };
    };
  };
in
{
  options.hardware.ethercat = {
    enable = lib.mkEnableOption "EtherCAT master support";

    masters = lib.mkOption {
      type = lib.types.listOf master;
      default = [ ];
      description = ''
        A list of EtherCAT master interfaces to configure.
      '';
    };

    deviceModules = lib.mkOption {
      description = ''
        A list of driver modules to load for EtherCAT operation.
      '';
      type = lib.types.listOf (
        lib.types.enum [
          "8139too"
          "e100"
          "e1000"
          "e1000e"
          "r8169"
          "generic"
          "ccat"
          "igb"
          "igc"
          "genet"
          "dwmac-intel"
          "stmmac-pci"
        ]
      );
      default = [ "generic" ];
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      extraModulePackages = [ config.boot.kernelPackages.ethercat ];
      kernelModules = [ "ec_master" ] ++ map (m: "ec_${m}") cfg.deviceModules;
      blacklistedKernelModules = builtins.filter (m: m != "generic" && m != "ccat") cfg.deviceModules;

      extraModprobeConfig =
        let
          mainDevices = map (m: m.primary) cfg.masters;
          backupDevices = map (m: "") cfg.masters;
        in
        ''
          options ec_master main_devices=${builtins.concatStringsSep "," mainDevices} backup_devices=${builtins.concatStringsSep "," backupDevices}
        '';
    };

    environment.systemPackages = [ pkgs.ethercat ];
  };
}
