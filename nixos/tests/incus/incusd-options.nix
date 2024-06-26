# this is a set of tests for non-default options. typically the default options
# will be handled by the other tests
import ../make-test-python.nix (
  {
    pkgs,
    lib,
    incus ? pkgs.incus-lts,
    ...
  }:

  let
    releases = import ../../release.nix {
      configuration = {
        # Building documentation makes the test unnecessarily take a longer time:
        documentation.enable = lib.mkForce false;
      };
    };

    container-image-metadata = releases.lxdContainerMeta.${pkgs.stdenv.hostPlatform.system};
    container-image-rootfs = releases.lxdContainerImage.${pkgs.stdenv.hostPlatform.system};
  in
  {
    name = "incusd-options";

    meta = {
      maintainers = lib.teams.lxc.members;
    };

    nodes.machine = {
      virtualisation = {
        cores = 2;
        memorySize = 1024;
        diskSize = 4096;

        incus = {
          enable = true;
          package = incus;
          softDaemonRestart = false;

          preseed = {
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
                name = "default";
                devices = {
                  eth0 = {
                    name = "eth0";
                    network = "nixostestbr0";
                    type = "nic";
                  };
                  root = {
                    path = "/";
                    pool = "nixostest_pool";
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
      networking.nftables.enable = true;
    };

    testScript = ''
      def instance_is_up(_) -> bool:
          status, _ = machine.execute("incus exec container --disable-stdin --force-interactive /run/current-system/sw/bin/systemctl -- is-system-running")
          return status == 0

      machine.wait_for_unit("incus.service")
      machine.wait_for_unit("incus-preseed.service")

      with subtest("Container image can be imported"):
          machine.succeed("incus image import ${container-image-metadata}/*/*.tar.xz ${container-image-rootfs}/*/*.tar.xz --alias nixos")

      with subtest("Container can be launched and managed"):
          machine.succeed("incus launch nixos container")
          with machine.nested("Waiting for instance to start and be usable"):
            retry(instance_is_up)
          machine.succeed("echo true | incus exec container /run/current-system/sw/bin/bash -")

      with subtest("Verify preseed resources created"):
          machine.succeed("incus profile show default")
          machine.succeed("incus network info nixostestbr0")
          machine.succeed("incus storage show nixostest_pool")

      with subtest("Instance is stopped when softDaemonRestart is disabled and services is stopped"):
          pid = machine.succeed("incus info container | grep 'PID'").split(":")[1].strip()
          machine.succeed(f"ps {pid}")
          machine.succeed("systemctl stop incus")
          machine.fail(f"ps {pid}")
    '';
  }
)
