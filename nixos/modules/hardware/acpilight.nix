{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.acpilight;
in
{
  options = {
    hardware.acpilight = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable acpilight.
          This will allow brightness control via xbacklight from users in the video group
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ acpilight ];
    services.udev.packages = with pkgs; [ acpilight ];
  };
}
