{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.bitcraze;
in
{
  options.hardware.bitcraze = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Bitcraze Crazyflie udev rules and ensure 'plugdev' group exists.
                This is a prerequisite to using Bitcraze Crazyflie devices without being root, since Bitcraze Crazyflie USB descriptors will be owned by plugdev through udev.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.bitcraze-udev-rules ];
    users.groups.plugdev = { };
  };

  meta.maintainers = with lib.maintainers; [
    vbruegge
    stargate01
  ];
}
