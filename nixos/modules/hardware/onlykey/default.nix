{ config, lib, ... }:
{

  ####### interface

  options = {

    hardware.onlykey = {
      enable = lib.mkOption {
        type = lib.types.bool;
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

  config = lib.mkIf config.hardware.onlykey.enable {
    services.udev.extraRules = builtins.readFile ./onlykey.udev;
  };


}
