# This module enables Network Address Translation (NAT).
# XXX: todo: support multiple upstream links
# see http://yesican.chsoft.biz/lartc/MultihomedLinuxNetworking.html

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.networking.nat;

in

{

  ###### interface

  options = {

    networking.nat.enable = mkOption {
      type = types.bool;
      default = false;
      description =
        ''
          Whether to enable Network Address Translation (NAT).
        '';
    };

    networking.nat.internalIPs = mkOption {
      type = types.listOf types.str;
      example = [ "192.168.1.0/24" ] ;
      description =
        ''
          The IP address ranges for which to perform NAT.  Packets
          coming from these networks and destined for the external
          interface will be rewritten.
        '';
    };

    networking.nat.externalInterface = mkOption {
      type = types.str;
      example = "eth1";
      description =
        ''
          The name of the external network interface.
        '';
    };

    networking.nat.externalIP = mkOption {
      type = types.nullOr types.str;
      default = null;
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
          ''
          + (concatMapStrings (network:
            ''
            iptables -t nat -A POSTROUTING \
              -s ${network} -o ${cfg.externalInterface} \
              ${if cfg.externalIP == null
                then "-j MASQUERADE"
                else "-j SNAT --to-source ${cfg.externalIP}"}
            ''
          ) cfg.internalIPs) +
          ''
            echo 1 > /proc/sys/net/ipv4/ip_forward
          '';

        postStop =
          ''
            iptables -t nat -F POSTROUTING
          '';
      };
  };
}
