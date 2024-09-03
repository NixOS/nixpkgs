import ../make-test-python.nix ({ pkgs, lib, incus ? pkgs.incus-lts, ... }:

let
  releases = import ../../release.nix {
    configuration = {
      # Building documentation makes the test unnecessarily take a longer time:
      documentation.enable = lib.mkForce false;

      # Our tests require `grep` & friends:
      environment.systemPackages = with pkgs; [busybox];
    };
  };

  vm-image-metadata = releases.incusVirtualMachineImageMeta.${pkgs.stdenv.hostPlatform.system};
  vm-image-disk = releases.incusVirtualMachineImage.${pkgs.stdenv.hostPlatform.system};

  instance-name = "instance1";
in
{
  name = "incus-virtual-machine";

  meta = {
    maintainers = lib.teams.lxc.members;
  };

  nodes.machine = {...}: {
    virtualisation = {
      # Ensure test VM has enough resources for creating and managing guests
      cores = 2;
      memorySize = 1024;
      diskSize = 4096;

      # Provide a TPM to test vTPM support for guests
      tpm.enable = true;

      incus = {
        enable = true;
        package = incus;
      };
    };
    networking.nftables.enable = true;
  };

  testScript = ''
    def instance_is_up(_) -> bool:
      status, _ = machine.execute("incus exec ${instance-name} --disable-stdin --force-interactive /run/current-system/sw/bin/systemctl -- is-system-running")
      return status == 0

    machine.wait_for_unit("incus.service")

    machine.succeed("incus admin init --minimal")

    with subtest("virtual-machine image can be imported"):
        machine.succeed("incus image import ${vm-image-metadata}/*/*.tar.xz ${vm-image-disk}/nixos.qcow2 --alias nixos")

    with subtest("virtual-machine can be created"):
        machine.succeed("incus create nixos ${instance-name} --vm --config limits.memory=512MB --config security.secureboot=false")

    with subtest("virtual tpm can be configured"):
        machine.succeed("incus config device add ${instance-name} vtpm tpm path=/dev/tpm0")

    with subtest("virtual-machine can be launched and become available"):
        machine.succeed("incus start ${instance-name}")
        with machine.nested("Waiting for instance to start and be usable"):
          retry(instance_is_up)

    with subtest("incus-agent is started"):
        machine.succeed("incus exec ${instance-name} systemctl is-active incus-agent")

    with subtest("incus-agent has a valid path"):
        machine.succeed("incus exec ${instance-name} -- bash -c 'true'")

    with subtest("guest supports cpu hotplug"):
        machine.succeed("incus config set ${instance-name} limits.cpu=1")
        count = int(machine.succeed("incus exec ${instance-name} -- nproc").strip())
        assert count == 1, f"Wrong number of CPUs reported, want: 1, got: {count}"

        machine.succeed("incus config set ${instance-name} limits.cpu=2")
        count = int(machine.succeed("incus exec ${instance-name} -- nproc").strip())
        assert count == 2, f"Wrong number of CPUs reported, want: 2, got: {count}"

    with subtest("Instance remains running when softDaemonRestart is enabled and services is stopped"):
        pid = machine.succeed("incus info ${instance-name} | grep 'PID'").split(":")[1].strip()
        machine.succeed(f"ps {pid}")
        machine.succeed("systemctl stop incus")
        machine.succeed(f"ps {pid}")
  '';
})
