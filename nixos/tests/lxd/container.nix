import ../make-test-python.nix ({ pkgs, lib, ... } :

let
  releases = import ../../release.nix {
    configuration = {
      # Building documentation makes the test unnecessarily take a longer time:
      documentation.enable = lib.mkForce false;

      # Our tests require `grep` & friends:
      environment.systemPackages = with pkgs; [ busybox ];
    };
  };

  lxd-image-metadata = releases.lxdContainerMeta.${pkgs.stdenv.hostPlatform.system};
  lxd-image-rootfs = releases.lxdContainerImage.${pkgs.stdenv.hostPlatform.system};

in {
  name = "lxd-container";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ patryk27 adamcstephens ];
  };

  nodes.machine = { lib, ... }: {
    virtualisation = {
      diskSize = 4096;

      # Since we're testing `limits.cpu`, we've gotta have a known number of
      # cores to lean on
      cores = 2;

      # Ditto, for `limits.memory`
      memorySize = 512;

      lxc.lxcfs.enable = true;
      lxd.enable = true;
    };
  };

  testScript = ''
    def instance_is_up(_) -> bool:
      status, _ = machine.execute("lxc exec container --disable-stdin --force-interactive /run/current-system/sw/bin/true")
      return status == 0

    machine.wait_for_unit("sockets.target")
    machine.wait_for_unit("lxd.service")
    machine.wait_for_file("/var/lib/lxd/unix.socket")

    # Wait for lxd to settle
    machine.succeed("lxd waitready")

    # no preseed should mean no service
    machine.fail("systemctl status lxd-preseed.service")

    machine.succeed("lxd init --minimal")

    machine.succeed(
        "lxc image import ${lxd-image-metadata}/*/*.tar.xz ${lxd-image-rootfs}/*/*.tar.xz --alias nixos"
    )

    with subtest("Container can be managed"):
        machine.succeed("lxc launch nixos container")
        with machine.nested("Waiting for instance to start and be usable"):
          retry(instance_is_up)
        machine.succeed("echo true | lxc exec container /run/current-system/sw/bin/bash -")
        machine.succeed("lxc delete -f container")

    with subtest("Container is mounted with lxcfs inside"):
        machine.succeed("lxc launch nixos container")
        with machine.nested("Waiting for instance to start and be usable"):
            retry(instance_is_up)

        ## ---------- ##
        ## limits.cpu ##

        machine.succeed("lxc config set container limits.cpu 1")
        machine.succeed("lxc restart container")
        with machine.nested("Waiting for instance to start and be usable"):
            retry(instance_is_up)

        assert (
            "1"
            == machine.succeed("lxc exec container grep -- -c ^processor /proc/cpuinfo").strip()
        )

        machine.succeed("lxc config set container limits.cpu 2")
        machine.succeed("lxc restart container")
        with machine.nested("Waiting for instance to start and be usable"):
            retry(instance_is_up)

        assert (
            "2"
            == machine.succeed("lxc exec container grep -- -c ^processor /proc/cpuinfo").strip()
        )

        ## ------------- ##
        ## limits.memory ##

        machine.succeed("lxc config set container limits.memory 64MB")
        machine.succeed("lxc restart container")
        with machine.nested("Waiting for instance to start and be usable"):
            retry(instance_is_up)

        assert (
            "MemTotal:          62500 kB"
            == machine.succeed("lxc exec container grep -- MemTotal /proc/meminfo").strip()
        )

        machine.succeed("lxc config set container limits.memory 128MB")
        machine.succeed("lxc restart container")
        with machine.nested("Waiting for instance to start and be usable"):
            retry(instance_is_up)

        assert (
            "MemTotal:         125000 kB"
            == machine.succeed("lxc exec container grep -- MemTotal /proc/meminfo").strip()
        )

        machine.succeed("lxc delete -f container")
  '';
})
