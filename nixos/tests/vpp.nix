# This test runs FD.io's VPP and tests routing between two virtual networks.
# Topology is similar to the `nat` test, with a client on one network, a server
# on another, and a VPP-powered router inbetween connecting the two.

{ pkgs, lib, ... }:
{
  name = "vpp";

  meta.maintainers = with lib.maintainers; [ maevii ];

  nodes = {
    client =
      { ... }:
      {
        virtualisation.vlans = [ 1 ];
        networking.interfaces = lib.mkForce {
          eth1.ipv6.addresses = [
            {
              address = "fd01::2";
              prefixLength = 64;
            }
          ];
        };
        networking.defaultGateway6 = "fd01::1";
        networking.useDHCP = false;
      };
    server =
      { ... }:
      {
        virtualisation.vlans = [ 2 ];
        networking.interfaces = lib.mkForce {
          eth1.ipv6.addresses = [
            {
              address = "fd02::2";
              prefixLength = 64;
            }
          ];
        };
        networking.defaultGateway6 = "fd02::1";
        networking.useDHCP = false;

        services.nginx.enable = true;
        services.nginx.statusPage = true;

        networking.firewall.allowedTCPPorts = [ 80 ];
      };
    router =
      { config, ... }:
      {
        virtualisation.vlans = [
          1
          2
        ];

        # disable netdevs so VPP can take over them
        networking.useDHCP = false;
        networking.interfaces = lib.mkForce { };

        # install & enable igb_uio driver
        boot.extraModulePackages = [ config.boot.kernelPackages.dpdk-kmods ];
        boot.kernelModules = [ "igb_uio" ];

        virtualisation.memorySize = 4096;
        boot.kernel.sysctl = {
          # see https://fd.io/docs/vpp/master/gettingstarted/running/index.html#huge-pages
          "vm.nr_hugepages" = 1024;
          "vm.max_map_count" = 2048;
          "kernel.shmmax" = 2147483648;
        };

        environment.systemPackages = [ pkgs.pciutils ];

        services.vpp = {
          enable = true;

          settings = {
            plugins = {
              plugin.default.disable = true;
              plugin."dpdk_plugin.so".enable = true;
            };

            dpdk.dev."0000:00:09.0".name = "vlan1";
            dpdk.dev."0000:00:0a.0".name = "vlan2";
          };

          startupConfig = ''
            set int state vlan1 up
            set int state vlan2 up
            set int ip addr vlan1 fd01::1/64
            set int ip addr vlan2 fd02::1/64
          '';
        };
      };
  };

  testScript = ''
    start_all()

    # wait for router
    router.wait_for_unit("vpp.service")

    # make sure VPP initialized correctly
    # wait_until_succeeds is necessary since startupConfig executes *after* the service starts
    router.wait_until_succeeds("vppctl show int addr | grep -A1 vlan1 | grep -q fd01::1/64")
    router.succeed("vppctl show int addr | grep -A1 vlan2 | grep -q fd02::1/64")

    # wait for server
    server.wait_for_unit("nginx.service")

    # wait for client, make sure it can connect to the server through the router
    client.wait_for_unit("network.target")
    client.succeed("curl --fail --connect-timeout 5 http://[fd02::2]")

    # disable interfaces in VPP, make sure server isn't reachable
    router.succeed("vppctl set int state vlan1 down")
    router.succeed("vppctl set int state vlan2 down")
    client.fail("curl --fail --connect-timeout 5 http://[fd02::2]")

    # restart VPP, make sure it restores its config & server becomes reachable again
    router.succeed("systemctl restart vpp")
    router.wait_for_unit("vpp.service")
    client.succeed("curl --fail --connect-timeout 5 http://[fd02::2]")
  '';
}
