{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {
    services.cjdns.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable this option to start a instance of the 
	cjdns network encryption and and routing engine.
	Configuration will be read from /etc/cjdroute.conf.
      '';
    };
  };

  config = {
    systemd.services.cjdns = {
      description = "encrypted networking for everybody";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
      before = [ "network.target" ];
      path = [ pkgs.cjdns ];

      serviceConfig = {
        Type = "forking";
	ExecStart = ''
          /bin/sh -c "${pkgs.cjdns}/sbin/cjdroute < /etc/cjdroute.conf"
	'';
	Restart = "on-failure";
      };
    };
  };
}