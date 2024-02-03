import ../make-test-python.nix ({ pkgs, lib, ... } :

{
  name = "incus-preseed";

  meta = {
    maintainers = lib.teams.lxc.members;
  };

  nodes.machine = { lib, ... }: {
    virtualisation = {
      incus.enable = true;

      incus.preseed = {
        networks = [
          {
            name = "nixostestbr0";
            type = "bridge";
            config = {
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
  };

  testScript = ''
    machine.wait_for_unit("incus.service")
    machine.wait_for_unit("incus-preseed.service")

    with subtest("Verify preseed resources created"):
      machine.succeed("incus profile show nixostest_default")
      machine.succeed("incus network info nixostestbr0")
      machine.succeed("incus storage show nixostest_pool")
  '';
})
