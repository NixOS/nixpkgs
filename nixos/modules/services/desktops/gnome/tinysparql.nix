# TinySPARQL daemon.

{ config, pkgs, lib, ... }:

let
  cfg = config.services.gnome.tinysparql;
in
{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  imports = [
    (lib.mkRemovedOptionModule [ "services" "gnome" "tracker" "subcommandPackages" ] ''
      This option is broken since 3.7 and since 3.8 tracker (tinysparql) no longer expect
      CLI to be extended by external projects, note that tracker-miners (localsearch) now
      provides its own CLI tool.
    '')
    (lib.mkRenamedOptionModule [ "services" "gnome" "tracker" "enable" ] [ "services" "gnome" "tinysparql" "enable" ])
  ];

  ###### interface

  options = {

    services.gnome.tinysparql = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable TinySPARQL services, a search engine,
          search tool and metadata storage system.
        '';
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.tracker ];

    services.dbus.packages = [ pkgs.tracker ];

    systemd.packages = [ pkgs.tracker ];

  };

}
