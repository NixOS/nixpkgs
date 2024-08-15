# LocalSearch daemons.

{ config, pkgs, lib, ... }:

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  imports = [
    (lib.mkRenamedOptionModule [ "services" "gnome" "tracker-miners" "enable" ] [ "services" "gnome" "localsearch" "enable" ])
  ];

  ###### interface

  options = {

    services.gnome.localsearch = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable LocalSearch, indexing services for TinySPARQL
          search engine and metadata storage system.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf config.services.gnome.localsearch.enable {

    environment.systemPackages = [ pkgs.tracker-miners ];

    services.dbus.packages = [ pkgs.tracker-miners ];

    systemd.packages = [ pkgs.tracker-miners ];

  };

}
