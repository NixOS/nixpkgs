{ lib, ... }:
{
  name = "flannel";

  meta.maintainers = with lib.maintainers; [ offline ];

  nodes =
    let
      flannelConfig = {
        services.flannel = {
          enable = true;
          backend = {
            Type = "udp";
            Port = 8285;
          };
          network = "10.1.0.0/16";
          iface = "eth1";
          etcd.endpoints = [ "http://etcd:2379" ];
        };

        networking.firewall.allowedUDPPorts = [ 8285 ];
      };
    in
    {
      etcd = {
        services.etcd = {
          enable = true;
          listenClientUrls = [ "http://0.0.0.0:2379" ]; # requires ip-address for binding
          listenPeerUrls = [ "http://0.0.0.0:2380" ]; # requires ip-address for binding
          advertiseClientUrls = [ "http://etcd:2379" ];
          initialAdvertisePeerUrls = [ "http://etcd:2379" ];
          initialCluster = [ "etcd=http://etcd:2379" ];
        };

        networking.firewall.allowedTCPPorts = [ 2379 ];
      };

      node1 = flannelConfig;
      node2 = flannelConfig;
    };

  testScript = ''
    start_all()

    node1.wait_for_unit("flannel.service")
    node2.wait_for_unit("flannel.service")

    node1.wait_until_succeeds("ip l show dev flannel0")
    ip1 = node1.succeed("ip -4 addr show flannel0 | grep -oP '(?<=inet).*(?=/)'")
    node2.wait_until_succeeds("ip l show dev flannel0")
    ip2 = node2.succeed("ip -4 addr show flannel0 | grep -oP '(?<=inet).*(?=/)'")

    node1.wait_until_succeeds(f"ping -c 1 {ip2}")
    node2.wait_until_succeeds(f"ping -c 1 {ip1}")
  '';
}
