# This test runs VPP and checks if VRRP works.
#
# Network topology:
#
#            +--------+
#            | server |
#            +--------+
#                |
#                |
#         +-------------+
#         |             |
#         |             |
#    +---------+   +---------+
#    | router1 |   | router2 |
#    +---------+   +---------+
#         |             |
#         |             |
#         +-------------+
#                |
#                |
#            +--------+
#            | client |
#            +--------+
#
# All interfaces are in same vlan.

import ./make-test-python.nix
  ({ pkgs, ... }:
  let
    lib = pkgs.lib;

    ifAddr = node: iface: (lib.head node.networking.interfaces.${iface}.ipv4.addresses).address;

    ifNetmask = node: iface: (lib.head node.networking.interfaces.${iface}.ipv4.addresses).prefixLength;

    ifCIDRAddr = node: iface:
      let
        addr = ifAddr node iface;
        netmask = builtins.toString (ifNetmask node iface);
      in
      builtins.concatStringsSep "/" [ addr netmask ];

    pow2 = n:
      if n == 0 then 1
      else 2 * (pow2 (n - 1));

    ipToInt = ip:
      let
        segments = lib.strings.splitString "." ip;
      in
      builtins.foldl' (res: segment: res * 256 + (lib.strings.toInt segment)) 0 segments;

    cidrToIntMask = cidr:
      let
        n = 32 - cidr;
      in
      (pow2 32) - (pow2 n);

    intToIp = int:
      let
        extractByte = n: lib.trivial.mod (builtins.div int (pow2 (n * 8))) 256;
      in
      builtins.concatStringsSep "." (builtins.map (n: builtins.toString (extractByte n)) [ 3 2 1 0 ]);

    deriveNetworkAddress = ip: cidr: builtins.bitAnd (ipToInt ip) (cidrToIntMask cidr);

    deriveBroadcastAddress = ip: cidr: (deriveNetworkAddress ip cidr) + (pow2 (32 - cidr)) - 1;

    deriveLastValidHost = ip: cidr: intToIp ((deriveBroadcastAddress ip cidr) - 1);

    routerConfig = {
      virtualisation = {
        cores = 2;
        memorySize = 4096;
        vlans = [ 1 2 ];
      };

      boot = {
        kernelPatches = [{
          name = "vfio-noiommu-config";
          patch = null;
          extraConfig = ''
            VFIO_NOIOMMU y
          '';
        }];

        kernelModules = [ "vfio-pci" ];
        kernelParams = [ "iommu=pt" "intel_iommu=on" ];
        kernel.sysctl = {
          "vm.nr_hugepages" = 1024;
          "vm.max_map_count" = 2048;
          "vm.hugetlb_shm_group" = 0;
          "kernel.shmmax" = 2147483648;
        };
        extraModprobeConfig = "options vfio enable_unsafe_noiommu_mode=1";
      };

      systemd.services = {
        disable-eth1 = {
          description = "Disable eth1 interface";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          before = [ "vpp.service" ];
          serviceConfig = {
            ExecStart = "${pkgs.iproute2}/bin/ip link set eth1 down";
            Type = "oneshot";
          };
        };
        disable-eth2 = {
          description = "Disable eth2 interface";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          before = [ "vpp.service" ];
          serviceConfig = {
            ExecStart = "${pkgs.iproute2}/bin/ip link set eth2 down";
            Type = "oneshot";
          };
        };
      };

      environment.systemPackages = [ pkgs.vpp ];

      services.vpp = {
        enable = true;
        unix = {
          nodaemon = true;
          full-coredump = true;
          gid = "vpp";
          cli-listen = "/run/vpp/cli.sock";
        };
        cpu = {
          main-core = 0;
          workers = 1;
        };
        dpdk = {
          dev = {
            "0000:00:09.0" = { };
            "0000:00:0a.0" = { };
          };
        };
      };
    };
  in
  {
    name = "vpp";

    meta = with pkgs.lib.maintainers; {
      maintainers = [ cariandrum22 ];
    };

    nodes = {
      client =
        { nodes, ... }:
        {
          virtualisation.vlans = [ 1 ];
          networking.defaultGateway = deriveLastValidHost (ifAddr nodes.router1 "eth1") (ifNetmask nodes.router1 "eth1");
        };

      router1 = { ... }: routerConfig;

      router2 = { ... }: routerConfig;

      server =
        { nodes, ... }:
        {
          virtualisation.vlans = [ 2 ];
          networking.defaultGateway = deriveLastValidHost (ifAddr nodes.router1 "eth2") (ifNetmask nodes.router1 "eth2");
        };
    };

    testScript =
      { nodes, ... }:
      ''
        def setup_interface(machine, interface, ip_address):
          machine.succeed(f"vppctl set interface ip address {interface} {ip_address}")
          machine.succeed(f"vppctl set interface state {interface} up")

        def setup_vrrp(machine, interface, vr_id, pri, peer_ip_address, virtual_ip_address):
          machine.succeed(f"vppctl vrrp vr add {interface} vr_id {vr_id} priority {pri} unicast accept_mode {virtual_ip_address}")
          machine.succeed(f"vppctl vrrp peers {interface} vr_id {vr_id} {peer_ip_address}")
          machine.succeed(f"vppctl vrrp proto start {interface} vr_id {vr_id}")

        start_all()

        # Wait for the networking to start on all machines
        for machine in client, router1, router2:
          machine.wait_for_unit("network.target")

        # wait for VPP
        with subtest("Wait for VPP"):
          for machine in router1, router2:
            machine.wait_for_unit("vpp.service")
            machine.wait_for_file("${routerConfig.services.vpp.unix.cli-listen}")

        with subtest("Run VPP"):
          for machine in router1, router2:
            machine.succeed("vppctl show version")

        with subtest("Configure VPP"):
          with subtest("Configure router1"):
            # setup interfaces
            setup_interface(router1, "GigabitEthernet0/9/0", "${ifCIDRAddr nodes.router1 "eth1"}")
            setup_interface(router1, "GigabitEthernet0/a/0", "${ifCIDRAddr nodes.router1 "eth2"}")

            # setup vrrp master
            setup_vrrp(router1, "GigabitEthernet0/9/0", 1, 200, "${ifAddr nodes.router2 "eth1"}", "${deriveLastValidHost (ifAddr nodes.router1 "eth1") (ifNetmask nodes.router1 "eth1")}")
            setup_vrrp(router1, "GigabitEthernet0/a/0", 2, 200, "${ifAddr nodes.router2 "eth2"}", "${deriveLastValidHost (ifAddr nodes.router1 "eth2") (ifNetmask nodes.router1 "eth2")}")

          with subtest("Configure router2"):
            # setup interfaces backup
            setup_interface(router2, "GigabitEthernet0/9/0", "${ifCIDRAddr nodes.router2 "eth1"}")
            setup_interface(router2, "GigabitEthernet0/a/0", "${ifCIDRAddr nodes.router2 "eth2"}")

            # setup vrrp bakcup
            setup_vrrp(router2, "GigabitEthernet0/9/0", 1, 100, "${ifAddr nodes.router2 "eth1"}", "${deriveLastValidHost (ifAddr nodes.router2 "eth1") (ifNetmask nodes.router2 "eth1")}")
            setup_vrrp(router2, "GigabitEthernet0/a/0", 2, 100, "${ifAddr nodes.router2 "eth2"}", "${deriveLastValidHost (ifAddr nodes.router2 "eth2") (ifNetmask nodes.router2 "eth2")}")

        with subtest("Check VPP"):
          router1.wait_until_succeeds("vppctl show int | grep 'GigabitEthernet0/9/0' | awk '{ exit ($3 == \"up\" ? 0 : 1) }'")
          router1.wait_until_succeeds("vppctl show int | grep 'GigabitEthernet0/a/0' | awk '{ exit ($3 == \"up\" ? 0 : 1) }'")
          router1.wait_until_succeeds("vppctl show vrrp vr | grep 'state Master' | wc -l | awk '{ exit ($1 >= 2 ? 0 : 1) }'")
          router2.wait_until_succeeds("vppctl show int | grep 'GigabitEthernet0/9/0' | awk '{ exit ($3 == \"up\" ? 0 : 1) }'")
          router2.wait_until_succeeds("vppctl show int | grep 'GigabitEthernet0/a/0' | awk '{ exit ($3 == \"up\" ? 0 : 1) }'")
          router2.wait_until_succeeds("vppctl show vrrp vr | grep 'state Backup' | wc -l | awk '{ exit ($1 >= 2 ? 0 : 1) }'")

        with subtest("Check IP reachability"):
          client.succeed("ping -c 10 ${ifAddr nodes.server "eth1"} >&2")
      '';
  })
