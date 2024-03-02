{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.glasgow;

in
{
  options.hardware.glasgow = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Enables Glasgow udev rules and ensures 'plugdev' group exists.
        This is a prerequisite to using Glasgow without being root.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.glasgow ];
    users.groups.plugdev = { };
  };
}
