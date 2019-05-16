# GeoClue 2 daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  # the demo agent isn't built by default, but we need it here
  package = pkgs.geoclue2.override { withDemoAgent = config.services.geoclue2.enableDemoAgent; };
in
{

  ###### interface

  options = {

    services.geoclue2 = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GeoClue 2 daemon, a DBus service
          that provides location information for accessing.
        '';
      };

      enableDemoAgent = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to use the GeoClue demo agent. This should be
          overridden by desktop environments that provide their own
          agent.
        '';
      };

    };

  };


  ###### implementation
  config = mkIf config.services.geoclue2.enable {

    environment.systemPackages = [ package ];

    services.dbus.packages = [ package ];

    systemd.packages = [ package ];
  
    # this needs to run as a user service, since it's associated with the
    # user who is making the requests
    systemd.user.services = mkIf config.services.geoclue2.enableDemoAgent { 
      "geoclue-agent" = {
        description = "Geoclue agent";
        script = "${package}/libexec/geoclue-2.0/demos/agent";
        # this should really be `partOf = [ "geoclue.service" ]`, but
        # we can't be part of a system service, and the agent should
        # be okay with the main service coming and going
        wantedBy = [ "default.target" ];
      };
    };

    environment.etc."geoclue/geoclue.conf".source = "${package}/etc/geoclue/geoclue.conf";
  };

}
