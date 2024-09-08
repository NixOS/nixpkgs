{ config, lib, pkgs, ... }:
let
  cfg = config.hardware;
in {

  imports = [
    (lib.mkRenamedOptionModule [ "networking" "enableRT73Firmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (lib.mkRenamedOptionModule [ "networking" "enableIntel3945ABGFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (lib.mkRenamedOptionModule [ "networking" "enableIntel2100BGFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (lib.mkRenamedOptionModule [ "networking" "enableRalinkFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
    (lib.mkRenamedOptionModule [ "networking" "enableRTL8192cFirmware" ] [ "hardware" "enableRedistributableFirmware" ])
  ];

  ###### interface

  options = {

    hardware.enableAllFirmware = lib.mkEnableOption "all firmware regardless of license";

    hardware.enableRedistributableFirmware = lib.mkEnableOption "firmware with a license allowing redistribution" // {
      default = config.hardware.enableAllFirmware;
      defaultText = lib.literalExpression "config.hardware.enableAllFirmware";
    };

    hardware.wirelessRegulatoryDatabase = lib.mkEnableOption "loading the wireless regulatory database at boot" // {
      default = cfg.enableRedistributableFirmware || cfg.enableAllFirmware;
      defaultText = lib.literalMD "Enabled if proprietary firmware is allowed via {option}`enableRedistributableFirmware` or {option}`enableAllFirmware`.";
    };

  };


  ###### implementation

  config = lib.mkMerge [
    (lib.mkIf (cfg.enableAllFirmware || cfg.enableRedistributableFirmware) {
      hardware.firmware = with pkgs; [
        linux-firmware
        intel2200BGFirmware
        rtl8192su-firmware
        rt5677-firmware
        rtl8761b-firmware
        zd1211fw
        alsa-firmware
        sof-firmware
        libreelec-dvb-firmware
      ] ++ lib.optional pkgs.stdenv.hostPlatform.isAarch raspberrypiWirelessFirmware;
    })
    (lib.mkIf cfg.enableAllFirmware {
      assertions = [{
        assertion = !cfg.enableAllFirmware || pkgs.config.allowUnfree;
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
      ] ++ lib.optionals pkgs.stdenv.hostPlatform.isx86 [
        facetimehd-calibration
        facetimehd-firmware
      ];
    })
    (lib.mkIf cfg.wirelessRegulatoryDatabase {
      hardware.firmware = [ pkgs.wireless-regdb ];
    })
  ];
}
