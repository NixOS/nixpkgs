{ networkd }:
{ config, pkgs, ... }:
let
  inherit (pkgs) lib;
  qemu-common = import ../../lib/qemu-common.nix { inherit lib pkgs; };
  vlanIfs = lib.range 1 (lib.length config.virtualisation.vlans);
in
{
  environment.systemPackages = [ pkgs.iptables ]; # to debug firewall rules
  virtualisation.vlans = [
    1
    2
    3
  ];
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  networking = {
    useDHCP = false;
    useNetworkd = networkd;
    firewall.checkReversePath = true;
    firewall.allowedUDPPorts = [ 547 ];
    interfaces = lib.mkOverride 0 (
      lib.listToAttrs (
        lib.forEach vlanIfs (
          n:
          lib.nameValuePair "eth${toString n}" {
            ipv4.addresses = [
              {
                address = "192.168.${toString n}.1";
                prefixLength = 24;
              }
            ];
            ipv6.addresses = [
              {
                address = "fd00:1234:5678:${toString n}::1";
                prefixLength = 64;
              }
            ];
          }
        )
      )
    );
  };
  services.kea = {
    dhcp4 = {
      enable = true;
      settings = {
        interfaces-config = {
          interfaces = map (n: "eth${toString n}") vlanIfs;
          dhcp-socket-type = "raw";
          service-sockets-require-all = true;
          service-sockets-max-retries = 5;
          service-sockets-retry-wait-time = 2500;
        };
        subnet4 = map (n: {
          id = n;
          subnet = "192.168.${toString n}.0/24";
          pools = [ { pool = "192.168.${toString n}.3 - 192.168.${toString n}.254"; } ];
          option-data = [
            {
              data = "192.168.${toString n}.1";
              name = "routers";
            }
            {
              data = "192.168.${toString n}.1";
              name = "domain-name-servers";
            }
          ];

          reservations = [
            {
              hw-address = qemu-common.qemuNicMac n 1;
              hostname = "client${toString n}";
              ip-address = "192.168.${toString n}.2";
            }
          ];
        }) vlanIfs;
      };
    };
    dhcp6 = {
      enable = true;
      settings = {
        interfaces-config = {
          interfaces = map (n: "eth${toString n}") vlanIfs;
          service-sockets-require-all = true;
          service-sockets-max-retries = 5;
          service-sockets-retry-wait-time = 2500;
        };

        subnet6 = map (n: {
          id = n;
          subnet = "fd00:1234:5678:${toString n}::/64";
          interface = "eth${toString n}";
          pools = [ { pool = "fd00:1234:5678:${toString n}::2-fd00:1234:5678:${toString n}::2"; } ];
        }) vlanIfs;
      };
    };
  };
  services.radvd = {
    enable = true;
    config = lib.flip lib.concatMapStrings vlanIfs (n: ''
      interface eth${toString n} {
        AdvSendAdvert on;
        AdvManagedFlag on;
        AdvOtherConfigFlag on;

        prefix fd00:1234:5678:${toString n}::/64 {
          AdvAutonomous off;
        };
      };
    '');
  };
}
