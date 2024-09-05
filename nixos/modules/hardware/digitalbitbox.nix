{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.digitalbitbox;
in

{
  options.hardware.digitalbitbox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enables udev rules for Digital Bitbox devices.
      '';
    };

    package = lib.mkPackageOption pkgs "digitalbitbox" {
      extraDescription = ''
        This can be used to install a package with udev rules that differ from the defaults.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
  };
}
