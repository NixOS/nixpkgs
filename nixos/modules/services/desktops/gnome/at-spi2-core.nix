# at-spi2-core daemon.

{ config, lib, pkgs, ... }:

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface
  options = {

    services.gnome.at-spi2-core = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable at-spi2-core, a service for the Assistive Technologies
          available on the GNOME platform.

          Enable this if you get the error or warning
          `The name org.a11y.Bus was not provided by any .service files`.
        '';
      };

    };

  };


  ###### implementation

  config = lib.mkMerge [
    (lib.mkIf config.services.gnome.at-spi2-core.enable {
      environment.systemPackages = [ pkgs.at-spi2-core ];
      services.dbus.packages = [ pkgs.at-spi2-core ];
      systemd.packages = [ pkgs.at-spi2-core ];
    })

    (lib.mkIf (!config.services.gnome.at-spi2-core.enable) {
      environment.sessionVariables = {
        NO_AT_BRIDGE = "1";
        GTK_A11Y = "none";
      };
    })
  ];
}
