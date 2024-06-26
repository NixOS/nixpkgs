import ../make-test-python.nix (
  { pkgs, lib, ... }:

  {
    name = "lxd-preseed";

    meta = {
      maintainers = lib.teams.lxc.members;
    };

    nodes.machine =
      { lib, ... }:
      {
        virtualisation = {
          diskSize = 4096;

          lxc.lxcfs.enable = true;
          lxd.enable = true;

          lxd.preseed = {
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
      def wait_for_preseed(_) -> bool:
        _, output = machine.systemctl("is-active lxd-preseed.service")
        return ("inactive" in output)

      machine.wait_for_unit("sockets.target")
      machine.wait_for_unit("lxd.service")
      with machine.nested("Waiting for preseed to complete"):
        retry(wait_for_preseed)

      with subtest("Verify preseed resources created"):
        machine.succeed("lxc profile show nixostest_default")
        machine.succeed("lxc network info nixostestbr0")
        machine.succeed("lxc storage show nixostest_pool")
    '';
  }
)
