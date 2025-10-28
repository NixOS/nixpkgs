{ config, lib, ... }:
let
  cfg = config.hardware.tuxedo-drivers;
  tuxedo-drivers = config.boot.kernelPackages.tuxedo-drivers;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "hardware"
        "tuxedo-keyboard"
      ]
      [
        "hardware"
        "tuxedo-drivers"
      ]
    )
  ];

  options.hardware.tuxedo-drivers = {
    enable = lib.mkEnableOption ''
      The tuxedo-drivers driver enables access to the following on TUXEDO notebooks:
      - Driver for Fn-keys
      - SysFS control of brightness/color/mode for most TUXEDO keyboards
      - Hardware I/O driver for TUXEDO Control Center

      For more inforation it is best to check at the source code description: <https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers>
    '';
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "tuxedo_keyboard" ];
    boot.extraModulePackages = [ tuxedo-drivers ];
    services.udev.packages = [ tuxedo-drivers ];
  };
}
