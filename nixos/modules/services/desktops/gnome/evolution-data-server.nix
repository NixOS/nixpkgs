# Evolution Data Server daemon.

{ config, lib, pkgs, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  # Added 2021-05-07
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "evolution-data-server" "enable" ]
      [ "services" "gnome" "evolution-data-server" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "gnome3" "evolution-data-server" "plugins" ]
      [ "services" "gnome" "evolution-data-server" "plugins" ]
    )
  ];

  ###### interface

  options = {

    services.gnome.evolution-data-server = {
      enable = mkEnableOption "Evolution Data Server, a collection of services for storing addressbooks and calendars.";
      plugins = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = "Plugins for Evolution Data Server.";
      };
    };
    programs.evolution = {
      enable = mkEnableOption "Evolution, a Personal information management application that provides integrated mail, calendaring and address book functionality.";
      plugins = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExample "[ pkgs.evolution-ews ]";
        description = "Plugins for Evolution.";
      };

    };
  };

  ###### implementation

  config =
    let
      bundle = pkgs.evolutionWithPlugins.override { inherit (config.services.gnome.evolution-data-server) plugins; };
    in
    mkMerge [
      (mkIf config.services.gnome.evolution-data-server.enable {
        environment.systemPackages = [ bundle ];

        services.dbus.packages = [ bundle ];

        systemd.packages = [ bundle ];
      })
      (mkIf config.programs.evolution.enable {
        services.gnome.evolution-data-server = {
          enable = true;
          plugins = [ pkgs.evolution ] ++ config.programs.evolution.plugins;
        };
        services.gnome.gnome-keyring.enable = true;
      })
    ];
}
