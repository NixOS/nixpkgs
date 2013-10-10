# Module for rdnssd, a daemon that configures DNS servers in
# /etc/resolv/conf from IPv6 RDNSS advertisements.

{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    services.rdnssd.enable = mkOption {
      default = false;
      #default = config.networking.enableIPv6;
      description =
        ''
          Whether to enable the RDNSS daemon
          (<command>rdnssd</command>), which configures DNS servers in
          <filename>/etc/resolv.conf</filename> from RDNSS
          advertisements sent by IPv6 routers.
        '';
    };

  };


  ###### implementation

  config = mkIf config.services.rdnssd.enable {

    jobs.rdnssd =
      { description = "RDNSS daemon";

        # Start before the network interfaces are brought up so that
        # the daemon receives RDNSS advertisements from the kernel.
        startOn = "starting network-interfaces";

        # !!! Should write to /var/run/rdnssd/resolv.conf and run the daemon under another uid.
        exec = "${pkgs.ndisc6}/sbin/rdnssd --resolv-file /etc/resolv.conf -u root";

        daemonType = "fork";
      };

  };

}
