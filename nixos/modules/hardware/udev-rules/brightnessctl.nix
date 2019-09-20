{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.brightnessctl;
in
{

  options = {

    hardware.brightnessctl = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable brightnessctl in userspace.
          This will allow brightness control from users in the video group.
        '';

      };
    };
  };


  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [ brightnessctl ];
    environment.systemPackages = with pkgs; [ brightnessctl ];
  };

}
