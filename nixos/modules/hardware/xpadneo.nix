{ config, lib, ... }:
let
  cfg = config.hardware.xpadneo;
in
{
  options.hardware.xpadneo = {
    enable = lib.mkEnableOption "the xpadneo driver for Xbox One wireless controllers";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      # Must disable Enhanced Retransmission Mode to support bluetooth pairing
      # https://wiki.archlinux.org/index.php/Gamepad#Connect_Xbox_Wireless_Controller_with_Bluetooth
      extraModprobeConfig = lib.mkIf (
        config.hardware.bluetooth.enable
        && (lib.versionOlder config.boot.kernelPackages.kernel.version "5.12")
      ) "options bluetooth disable_ertm=1";

      extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
      kernelModules = [ "hid_xpadneo" ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ kira-bruneau ];
  };
}
