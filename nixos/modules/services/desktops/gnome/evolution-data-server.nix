# Evolution Data Server daemon.

{
  config,
  lib,
  pkgs,
  ...
}:

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome.evolution-data-server = {
      enable = lib.mkEnableOption "Evolution Data Server, a collection of services for storing addressbooks and calendars";
      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Plugins for Evolution Data Server.";
      };
    };
    programs.evolution = {
      enable = lib.mkEnableOption "Evolution, a Personal information management application that provides integrated mail, calendaring and address book functionality";
      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.evolution-ews ]";
        description = "Plugins for Evolution.";
      };

    };
  };

  ###### implementation

  config =
    let
      bundle = pkgs.evolutionWithPlugins.override {
        inherit (config.services.gnome.evolution-data-server) plugins;
      };
    in
    lib.mkMerge [
      (lib.mkIf config.services.gnome.evolution-data-server.enable {
        environment.systemPackages = [ bundle ];

        services.dbus.packages = [ bundle ];

        systemd.packages = [ bundle ];
      })
      (lib.mkIf config.programs.evolution.enable {
        services.gnome.evolution-data-server = {
          enable = true;
          plugins = [ pkgs.evolution ] ++ config.programs.evolution.plugins;
        };
        services.gnome.gnome-keyring.enable = true;
      })
    ];
}
