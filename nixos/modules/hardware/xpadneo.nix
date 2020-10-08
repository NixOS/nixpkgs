{ config, lib, ... }:

with lib;
let
  cfg = config.hardware.xpadneo;
in
{
  options.hardware.xpadneo = {
    enable = mkEnableOption "the xpadneo driver for Xbox One wireless controllers";
  };

  config = mkIf cfg.enable {
    boot = {
      # Must disable Enhanced Retransmission Mode to support bluetooth pairing
      # https://wiki.archlinux.org/index.php/Gamepad#Connect_Xbox_Wireless_Controller_with_Bluetooth
      extraModprobeConfig =
        mkIf
          config.hardware.bluetooth.enable
          "options bluetooth disable_ertm=1";

      extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
      kernelModules = [ "hid_xpadneo" ];
    };
  };

  meta = {
    maintainers = with maintainers; [ metadark ];
  };
}
