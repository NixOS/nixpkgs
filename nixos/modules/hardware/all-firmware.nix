{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware;
in {

  ###### interface

  options = {

    hardware.enableAllFirmware = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Turn on this option if you want to enable all the firmware.
      '';
    };

    hardware.enableRedistributableFirmware = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Turn on this option if you want to enable all the firmware with a license allowing redistribution.
        (i.e. free firmware and <literal>firmware-linux-nonfree</literal>)
      '';
    };

  };


  ###### implementation

  config = mkMerge [
    (mkIf (cfg.enableAllFirmware || cfg.enableRedistributableFirmware) {
      hardware.firmware = with pkgs; [
        firmwareLinuxNonfree
        intel2200BGFirmware
        rtl8192su-firmware
        rt5677-firmware
        rtl8723bs-firmware
        rtlwifi_new-firmware
        zd1211fw
        alsa-firmware
        openelec-dvb-firmware
      ] ++ optional (pkgs.stdenv.hostPlatform.isAarch32 || pkgs.stdenv.hostPlatform.isAarch64) raspberrypiWirelessFirmware
        ++ optionals (versionOlder config.boot.kernelPackages.kernel.version "4.13") [
        rtl8723bs-firmware
      ];
    })
    (mkIf cfg.enableAllFirmware {
      assertions = [{
        assertion = !cfg.enableAllFirmware || (config.nixpkgs.config.allowUnfree or false);
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
        b43FirmwareCutter
        facetimehd-firmware
      ];
    })
  ];
}
