{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gdomap;
in
{
  #
  # interface
  #
  options = {
    services.gdomap = {
      enable = mkOption {
        default = false;
	description = "
	  Whether to enable gdomap, the GNUstep distributed objects daemon.

	  Note that gdomap runs as root.
        ";
      };

      pidfile = mkOption {
        type = types.path;
        default = "/tmp/gdomap.pid";
	description = "Location of the pid file for gdomap daemon";
      };
    };
  };
  #
  # implementation
  #
  config = mkIf config.services.gdomap.enable {
    # NOTE: gdomap runs as root
    # TODO: extra user for gdomap?
    systemd.services.gdomap = {
      description = "gdomap server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path  = [ pkgs.gnustep_base ];
      serviceConfig = {
        PIDFile = cfg.pidfile;
        ExecStart = "@${pkgs.gnustep_base}/bin/gdomap"
	  + " -d -p"
	  + " -I ${cfg.pidfile}";
	Restart = "always";
	RestartSec = 2;
	TimeoutStartSec = "30";
	Type = "forking";
      };
    };
  };
}
