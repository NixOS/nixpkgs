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
      enable = mkEnableOption "Whether to enable gdomap, the GNUstep distributed objects daemon";
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
      path  = [ pkgs.gnustep.base ];
      serviceConfig = {
        PIDFile = cfg.pidfile;
        ExecStart = "@${pkgs.gnustep.base}/bin/gdomap"
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
