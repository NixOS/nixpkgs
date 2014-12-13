{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gdomap;
  stateDir = "/var/lib/gdomap";
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
    };
  };
  #
  # implementation
  #
  config = mkIf config.services.gdomap.enable {
    # NOTE: gdomap runs as root
    systemd.services.gdomap = {
      description = "gdomap server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path  = [ pkgs.gnustep_base ];
      preStart = ''
	mkdir -m 755 -p ${stateDir}
	mkdir -m 755 -p /run/gdomap
      '';
      serviceConfig = {
        # NOTE: this is local-only configuration!
        ExecStart = "@${pkgs.gnustep_base}/bin/gdomap"
	  + " -j ${stateDir} -p";
	Restart = "always"; # "no";
	RestartSec = 2;
	TimeoutStartSec = "30";
	Type = "forking";
      };
    };
  };
}