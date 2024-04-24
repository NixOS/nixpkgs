{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.hackrf;

in
{
  options.hardware.hackrf = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enables hackrf udev rules and ensures 'plugdev' group exists.
        This is a prerequisite to using HackRF devices without being root, since HackRF USB descriptors will be owned by plugdev through udev.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.hackrf ];
    users.groups.plugdev = { };
  };
}
