import ../make-test-python.nix ({ pkgs, lib, extra ? {}, name ? "incus-container", incus ? pkgs.incus-lts, ... } :

let
  releases = import ../../release.nix {
    configuration = lib.recursiveUpdate {
        # Building documentation makes the test unnecessarily take a longer time:
        documentation.enable = lib.mkForce false;

        boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
    }
    extra;
  };

  container-image-metadata = releases.lxdContainerMeta.${pkgs.stdenv.hostPlatform.system};
  container-image-rootfs = releases.lxdContainerImage.${pkgs.stdenv.hostPlatform.system};
in
{
  inherit name;

  meta = {
    maintainers = lib.teams.lxc.members;
  };

  nodes.machine = { ... }: {
    virtualisation = {
      # Ensure test VM has enough resources for creating and managing guests
      cores = 2;
      memorySize = 1024;
      diskSize = 4096;

      incus = {
        enable = true;
        package = incus;
      };
    };
    networking.nftables.enable = true;
  };

  testScript = ''
    def instance_is_up(_) -> bool:
        status, _ = machine.execute("incus exec container --disable-stdin --force-interactive /run/current-system/sw/bin/systemctl -- is-system-running")
        return status == 0

    def set_container(config):
        machine.succeed(f"incus config set container {config}")
        machine.succeed("incus restart container")
        with machine.nested("Waiting for instance to start and be usable"):
          retry(instance_is_up)

    def check_sysctl(instance):
        with subtest("systemd sysctl settings are applied"):
            machine.succeed(f"incus exec {instance} -- systemctl status systemd-sysctl")
            sysctl = machine.succeed(f"incus exec {instance} -- sysctl net.ipv4.ip_forward").strip().split(" ")[-1]
            assert "1" == sysctl, f"systemd-sysctl configuration not correctly applied, {sysctl} != 1"

    machine.wait_for_unit("incus.service")

    # no preseed should mean no service
    machine.fail("systemctl status incus-preseed.service")

    machine.succeed("incus admin init --minimal")

    with subtest("Container image can be imported"):
        machine.succeed("incus image import ${container-image-metadata}/*/*.tar.xz ${container-image-rootfs}/*/*.tar.xz --alias nixos")

    with subtest("Container can be launched and managed"):
        machine.succeed("incus launch nixos container")
        with machine.nested("Waiting for instance to start and be usable"):
          retry(instance_is_up)
        machine.succeed("echo true | incus exec container /run/current-system/sw/bin/bash -")

    with subtest("Container mounts lxcfs overlays"):
        machine.succeed("incus exec container mount | grep 'lxcfs on /proc/cpuinfo type fuse.lxcfs'")
        machine.succeed("incus exec container mount | grep 'lxcfs on /proc/meminfo type fuse.lxcfs'")

    with subtest("resource limits"):
        with subtest("Container CPU limits can be managed"):
            set_container("limits.cpu 1")
            cpuinfo = machine.succeed("incus exec container grep -- -c ^processor /proc/cpuinfo").strip()
            assert cpuinfo == "1", f"Wrong number of CPUs reported from /proc/cpuinfo, want: 1, got: {cpuinfo}"

            set_container("limits.cpu 2")
            cpuinfo = machine.succeed("incus exec container grep -- -c ^processor /proc/cpuinfo").strip()
            assert cpuinfo == "2", f"Wrong number of CPUs reported from /proc/cpuinfo, want: 2, got: {cpuinfo}"

        with subtest("Container memory limits can be managed"):
            set_container("limits.memory 64MB")
            meminfo = machine.succeed("incus exec container grep -- MemTotal /proc/meminfo").strip()
            meminfo_bytes = " ".join(meminfo.split(' ')[-2:])
            assert meminfo_bytes == "62500 kB", f"Wrong amount of memory reported from /proc/meminfo, want: '62500 kB', got: '{meminfo_bytes}'"

            set_container("limits.memory 128MB")
            meminfo = machine.succeed("incus exec container grep -- MemTotal /proc/meminfo").strip()
            meminfo_bytes = " ".join(meminfo.split(' ')[-2:])
            assert meminfo_bytes == "125000 kB", f"Wrong amount of memory reported from /proc/meminfo, want: '125000 kB', got: '{meminfo_bytes}'"

    with subtest("lxc-generator"):
        with subtest("lxc-container generator configures plain container"):
            # reuse the existing container to save some time
            machine.succeed("incus exec container test -- -e /run/systemd/system/service.d/zzz-lxc-service.conf")
            check_sysctl("container")

        with subtest("lxc-container generator configures nested container"):
            machine.execute("incus delete --force container")
            machine.succeed("incus launch nixos container --config security.nesting=true")
            with machine.nested("Waiting for instance to start and be usable"):
              retry(instance_is_up)

            machine.fail("incus exec container test -- -e /run/systemd/system/service.d/zzz-lxc-service.conf")
            target = machine.succeed("incus exec container readlink -- -f /run/systemd/system/systemd-binfmt.service").strip()
            assert target == "/dev/null", "lxc generator did not correctly mask /run/systemd/system/systemd-binfmt.service"

            check_sysctl("container")

        with subtest("lxc-container generator configures privileged container"):
            machine.execute("incus delete --force container")
            machine.succeed("incus launch nixos container --config security.privileged=true")
            with machine.nested("Waiting for instance to start and be usable"):
              retry(instance_is_up)

            machine.succeed("incus exec container test -- -e /run/systemd/system/service.d/zzz-lxc-service.conf")

            check_sysctl("container")

    with subtest("softDaemonRestart"):
        with subtest("Instance remains running when softDaemonRestart is enabled and services is stopped"):
            pid = machine.succeed("incus info container | grep 'PID'").split(":")[1].strip()
            machine.succeed(f"ps {pid}")
            machine.succeed("systemctl stop incus")
            machine.succeed(f"ps {pid}")
  '';
})
