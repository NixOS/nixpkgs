# at-spi2-core daemon.

{ config, lib, pkgs, ... }:

with lib;

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

          Enable this if you get the error or warning
          <literal>The name org.a11y.Bus was not provided by any .service files</literal>.
        '';
      };

    };

  };


  ###### implementation

  config = mkMerge [
    (mkIf config.services.gnome3.at-spi2-core.enable {
      environment.systemPackages = [ pkgs.at-spi2-core ];
      services.dbus.packages = [ pkgs.at-spi2-core ];
      systemd.packages = [ pkgs.at-spi2-core ];
    })

    (mkIf (!config.services.gnome3.at-spi2-core.enable) {
      environment.variables.NO_AT_BRIDGE = "1";
    })
  ];
}
