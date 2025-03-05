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

    container-image-metadata = "${
      releases.incusContainerMeta.${pkgs.stdenv.hostPlatform.system}
    }/tarball/nixos-system-${pkgs.stdenv.hostPlatform.system}.tar.xz";
    container-image-rootfs = "${
      releases.incusContainerImage.${pkgs.stdenv.hostPlatform.system}
    }/nixos-lxc-image-${pkgs.stdenv.hostPlatform.system}.squashfs";
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
                name = "incusbr0";
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
                    network = "incusbr0";
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
                name = "default";
                driver = "dir";
              }
            ];
          };
        };

      };

      networking.nftables.enable = true;

      users.users.testuser = {
        isNormalUser = true;
        shell = pkgs.bashInteractive;
        group = "incus";
        uid = 1000;
      };
    };

    testScript = # python
      ''
        def wait_for_instance(name: str, project: str = "default"):
            def instance_is_up(_) -> bool:
                status, _ = machine.execute(f"incus exec {name} --disable-stdin --force-interactive --project {project} -- /run/current-system/sw/bin/systemctl is-system-running")
                return status == 0

            with machine.nested(f"Waiting for instance {name} to start and be usable"):
              retry(instance_is_up)

        machine.wait_for_unit("incus.service")
        machine.wait_for_unit("incus-preseed.service")

        with subtest("Container image can be imported"):
            machine.succeed("incus image import ${container-image-metadata} ${container-image-rootfs} --alias nixos")

        with subtest("Container can be launched and managed"):
            machine.succeed("incus launch nixos instance1")
            wait_for_instance("instance1")
            machine.succeed("echo true | incus exec instance1 /run/current-system/sw/bin/bash -")

        with subtest("Verify preseed resources created"):
            machine.succeed("incus profile show default")
            machine.succeed("incus network info incusbr0")
            machine.succeed("incus storage show default")

        with subtest("Instance is stopped when softDaemonRestart is disabled and services is stopped"):
            pid = machine.succeed("incus info instance1 | grep 'PID'").split(":")[1].strip()
            machine.succeed(f"ps {pid}")
            machine.succeed("systemctl stop incus")
            machine.fail(f"ps {pid}")

        with subtest("incus-user allows restricted access for users"):
            machine.fail("incus project show user-1000")
            machine.succeed("su - testuser bash -c 'incus list'")
            # a project is created dynamically for the user
            machine.succeed("incus project show user-1000")
            # users shouldn't be able to list storage pools
            machine.fail("su - testuser bash -c 'incus storage list'")

        with subtest("incus-user allows users to launch instances"):
            machine.succeed("su - testuser bash -c 'incus image import ${container-image-metadata} ${container-image-rootfs} --alias nixos'")
            machine.succeed("su - testuser bash -c 'incus launch nixos instance2'")
            wait_for_instance("instance2", "user-1000")
      '';
  }
)
