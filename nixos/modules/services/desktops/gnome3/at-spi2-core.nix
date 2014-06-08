# at-spi2-core daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
{

  ###### interface

  options = {

    services.gnome3.at-spi2-core = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable at-spi2-core, a service for the Assistive Technologies
          available on the GNOME platform.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.at-spi2-core.enable {

    environment.systemPackages = [ gnome3.at_spi2_core ];

    services.dbus.packages = [ gnome3.at_spi2_core ];

  };

}
