{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.hardware.digitalbitbox;
in

{
  options.hardware.digitalbitbox = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables udev rules for Digital Bitbox devices.
      '';
    };

    package = mkPackageOption pkgs "digitalbitbox" {
      extraDescription = ''
        This can be used to install a package with udev rules that differ from the defaults.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
  };
}
