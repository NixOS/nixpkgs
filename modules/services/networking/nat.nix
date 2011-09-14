# This module enables Network Address Translation (NAT).

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.networking.nat;

in

{

  ###### interface

  options = {

    networking.nat.enable = mkOption {
      default = false;
      description =
        ''
          Whether to enable Network Address Translation (NAT).
        '';
    };

    networking.nat.internalIPs = mkOption {
      example = "192.168.1.0/24";
      description =
        ''
          The IP address range for which to perform NAT.  Packets
          coming from these addresses and destined for the external
          interface will be rewritten.
        '';
    };

    networking.nat.externalInterface = mkOption {
      example = "eth1";
      description =
        ''
          The name of the external network interface.
        '';
    };

    networking.nat.externalIP = mkOption {
      default = "";
      example = "203.0.113.123";
      description =
        ''
          The public IP address to which packets from the local
          network are to be rewritten.  If this is left empty, the
          IP address associated with the external interface will be
          used.
        '';
    };

  };


  ###### implementation

  config = mkIf config.networking.nat.enable {

    environment.systemPackages = [ pkgs.iptables ];

    boot.kernelModules = [ "nf_nat_ftp" ];

    jobs.nat =
      { description = "Network Address Translation";

        startOn = "started network-interfaces";

        path = [ pkgs.iptables ];

        preStart =
          ''
            iptables -t nat -F POSTROUTING
            iptables -t nat -X

            iptables -t nat -A POSTROUTING \
              -s ${cfg.internalIPs} -o ${cfg.externalInterface} \
              ${if cfg.externalIP == ""
                then "-j MASQUERADE"
                else "-j SNAT --to-source ${cfg.externalIP}"}

            echo 1 > /proc/sys/net/ipv4/ip_forward
          '';

        postStop =
          ''
            iptables -t nat -F POSTROUTING
          '';
      };

  };

}
