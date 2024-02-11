# at-spi2-core daemon.

{ config, lib, pkgs, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  ###### interface

  # Added 2021-05-07
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "at-spi2-core" "enable" ]
      [ "services" "gnome" "at-spi2-core" "enable" ]
    )
  ];

  options = {

    services.gnome.at-spi2-core = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable at-spi2-core, a service for the Assistive Technologies
          available on the GNOME platform.

          Enable this if you get the error or warning
          `The name org.a11y.Bus was not provided by any .service files`.
        '';
      };

    };

  };


  ###### implementation

  config = mkMerge [
    (mkIf config.services.gnome.at-spi2-core.enable {
      environment.systemPackages = [ pkgs.at-spi2-core ];
      services.dbus.packages = [ pkgs.at-spi2-core ];
      systemd.packages = [ pkgs.at-spi2-core ];
    })

    (mkIf (!config.services.gnome.at-spi2-core.enable) {
      environment.sessionVariables = {
        NO_AT_BRIDGE = "1";
        GTK_A11Y = "none";
      };
    })
  ];
}
