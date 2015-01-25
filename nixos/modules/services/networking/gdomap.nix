{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gdomap;
  pidFile = "${cfg.pidDir}/gdomap.pid";
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
      pidDir = mkOption {
        default = "/var/run/gdomap";
	description = "Location of the file which stores the PID of gdomap";
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
      preStart = ''
        mkdir -m 0700 -p ${cfg.pidDir}
	chown -R nobody:nobody ${cfg.pidDir}
      '';
      serviceConfig = {
        ExecStart = "@${pkgs.gnustep_base}/bin/gdomap"
	  + " -d -p"
	  + " -I ${pidFile}";
#	  + " -j ${cfg.pidDir}";
	Restart = "always";
	RestartSec = 2;
	TimeoutStartSec = "30";
	Type = "forking";
      };
    };
  };
}