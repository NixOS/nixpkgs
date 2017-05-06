{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    hardware.enableAllFirmware = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Turn on this option if you want to enable all the firmware shipped in linux-firmware. For unfree firmware, see <literal>hardware.enableAllUnfreeFirmware</literal>.
      '';
    };
    hardware.enableAllUnfreeFirmware = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Turn on this option if you want to enable all the firmware shipped in linux-firmware that has an unfree license.
      '';
    };

  };


  ###### implementation

  config = mkMerge [
    (mkIf config.hardware.enableAllFirmware {
      hardware.firmware = with pkgs; [
        firmwareLinuxNonfree
        intel2200BGFirmware
        rtl8723bs-firmware
        rtl8192su-firmware
      ];
    })
    (mkIf config.hardware.enableAllUnfreeFirmware {
      hardware.firmware = with pkgs; [
        broadcom-bt-firmware
      ];
    })
  ];

}
