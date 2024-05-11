import ../make-test-python.nix ({ pkgs, lib, incus ? pkgs.incus-lts, ... } :

{
  name = "incus-openvswitch";

  meta = {
    maintainers = lib.teams.lxc.members;
  };

  nodes.machine = { lib, ... }: {
    virtualisation = {
      incus = {
        enable = true;
        package = incus;
      };

      vswitch.enable = true;
      incus.preseed = {
        networks = [
          {
            name = "nixostestbr0";
            type = "bridge";
            config = {
              "bridge.driver" = "openvswitch";
              "ipv4.address" = "10.0.100.1/24";
              "ipv4.nat" = "true";
            };
          }
        ];
        profiles = [
          {
            name = "nixostest_default";
            devices = {
              eth0 = {
                name = "eth0";
                network = "nixostestbr0";
                type = "nic";
              };
              root = {
                path = "/";
                pool = "default";
                size = "35GiB";
                type = "disk";
              };
            };
          }
        ];
        storage_pools = [
          {
            name = "nixostest_pool";
            driver = "dir";
          }
        ];
      };
    };
    networking.nftables.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("incus.service")
    machine.wait_for_unit("incus-preseed.service")

    with subtest("Verify openvswitch bridge"):
      machine.succeed("incus network info nixostestbr0")

    with subtest("Verify openvswitch bridge"):
      machine.succeed("ovs-vsctl br-exists nixostestbr0")
  '';
})
