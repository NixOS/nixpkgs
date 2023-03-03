{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware;
in {

  imports = [
    (mkRenamedOptionModule [ "networking" "enableRT73Firmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (mkRenamedOptionModule [ "networking" "enableIntel3945ABGFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (mkRenamedOptionModule [ "networking" "enableIntel2100BGFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (mkRenamedOptionModule [ "networking" "enableRalinkFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (mkRenamedOptionModule [ "networking" "enableRTL8192cFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
  ];

  ###### interface

  options = {

    hardware.enableAllFirmware = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
        Turn on this option if you want to enable all the firmware.
      '';
    };

    hardware.enableRedistributableFirmware = mkOption {
      default = config.hardware.enableAllFirmware;
      defaultText = lib.literalExpression "config.hardware.enableAllFirmware";
      type = types.bool;
      description = lib.mdDoc ''
        Turn on this option if you want to enable all the firmware with a license allowing redistribution.
      '';
    };

    hardware.wirelessRegulatoryDatabase = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
        Load the wireless regulatory database at boot.
      '';
    };

  };


  ###### implementation

  config = mkMerge [
    (mkIf (cfg.enableAllFirmware || cfg.enableRedistributableFirmware) {
      hardware.firmware = with pkgs; [
        linux-firmware
        intel2200BGFirmware
        rtl8192su-firmware
        rt5677-firmware
        rtl8723bs-firmware
        rtl8761b-firmware
        rtw88-firmware
        zd1211fw
        alsa-firmware
        sof-firmware
        libreelec-dvb-firmware
      ] ++ optional pkgs.stdenv.hostPlatform.isAarch raspberrypiWirelessFirmware
        ++ optionals (versionOlder config.boot.kernelPackages.kernel.version "4.13") [
        rtl8723bs-firmware
      ];
      hardware.wirelessRegulatoryDatabase = true;
    })
    (mkIf cfg.enableAllFirmware {
      assertions = [{
        assertion = !cfg.enableAllFirmware || config.nixpkgs.config.allowUnfree;
        message = ''
          the list of hardware.enableAllFirmware contains non-redistributable licensed firmware files.
            This requires nixpkgs.config.allowUnfree to be true.
            An alternative is to use the hardware.enableRedistributableFirmware option.
        '';
      }];
      hardware.firmware = with pkgs; [
        broadcom-bt-firmware
        b43Firmware_5_1_138
        b43Firmware_6_30_163_46
        xow_dongle-firmware
      ] ++ optionals pkgs.stdenv.hostPlatform.isx86 [
        facetimehd-calibration
        facetimehd-firmware
      ];
    })
    (mkIf cfg.wirelessRegulatoryDatabase {
      hardware.firmware = [ pkgs.wireless-regdb ];
    })
  ];
}
