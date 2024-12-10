{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.hardware.brillo;
in
{
  options = {
    hardware.brillo = {
      enable = mkEnableOption ''
        brillo in userspace.
        This will allow brightness control from users in the video group
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.brillo ];
    environment.systemPackages = [ pkgs.brillo ];
  };
}
