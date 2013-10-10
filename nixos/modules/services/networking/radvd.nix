# Module for the IPv6 Router Advertisement Daemon.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.radvd;

  confFile = pkgs.writeText "radvd.conf" cfg.config;

in

{

  ###### interface

  options = {

    services.radvd.enable = mkOption {
      default = false;
      description =
        ''
          Whether to enable the Router Advertisement Daemon
          (<command>radvd</command>), which provides link-local
          advertisements of IPv6 router addresses and prefixes using
          the Neighbor Discovery Protocol (NDP).  This enables
          stateless address autoconfiguration in IPv6 clients on the
          network.
        '';
    };

    services.radvd.config = mkOption {
      example =
        ''
          interface eth0 {
            AdvSendAdvert on;
            prefix 2001:db8:1234:5678::/64 { };
          };
        '';
      description =
        ''
          The contents of the radvd configuration file.
        '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.radvd ];

    jobs.radvd =
      { description = "IPv6 Router Advertisement Daemon";

        startOn = "started network-interfaces";

        preStart =
          ''
            # !!! Radvd only works if IPv6 forwarding is enabled.  But
            # this should probably be done somewhere else (and not
            # necessarily for all interfaces).
            echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
          '';

        exec = "${pkgs.radvd}/sbin/radvd -m syslog -s -C ${confFile}";

        daemonType = "fork";
      };

  };

}
