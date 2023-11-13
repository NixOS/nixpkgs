{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.acpilight;
in
{
  options = {
    hardware.acpilight = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable acpilight.
          This will allow brightness control via xbacklight from users in the video group
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ acpilight ];
    services.udev.packages = with pkgs; [ acpilight ];
  };
}
