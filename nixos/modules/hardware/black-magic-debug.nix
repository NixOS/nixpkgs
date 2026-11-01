{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.blackMagicDebug;
in
{
  options.hardware.blackMagicDebug.enable = lib.mkEnableOption ''
    Enables Black Magic Debug udev rules, installs the utilities and ensures 'plugdev' group exists.
    This is a prerequisite to using Black Magic debug devices without being root.
    Ensure your user is a member of the 'plugdev' group after enabling.
  '';

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.bmputil ];
    services.udev.packages = [ pkgs.bmputil ];

    users.groups.plugdev = { };
  };
}
