{ config, lib, ... }:

with lib;

{

  ####### interface

  options = {

    hardware.onlykey = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable OnlyKey device (https://crp.to/p/) support.
        '';
      };
    };

  };

  ## As per OnlyKey's documentation piece (hhttps://docs.google.com/document/d/1Go_Rs218fKUx-j_JKhddbSVTqY6P0vQO831t2MKCJC8),
  ## it is important to add udev rule for OnlyKey for it to work on Linux

  ####### implementation

  config = mkIf config.hardware.onlykey.enable {
    services.udev.extraRules = ''
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", GROUP+="plugdev"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", GROUP+="plugdev"
    '';
  };


}
