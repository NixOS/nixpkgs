{ config, lib, pkgs, ... }:

with lib;
{
<<<<<<< HEAD
  options.hardware.wooting.enable = mkEnableOption (lib.mdDoc ''support for Wooting keyboards.
    Note that users must be in the "input" group for udev rules to apply'');
=======
  options.hardware.wooting.enable =
    mkEnableOption (lib.mdDoc "support for Wooting keyboards");
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  config = mkIf config.hardware.wooting.enable {
    environment.systemPackages = [ pkgs.wootility ];
    services.udev.packages = [ pkgs.wooting-udev-rules ];
  };
}
