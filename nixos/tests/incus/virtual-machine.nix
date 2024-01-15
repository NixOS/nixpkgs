import ../make-test-python.nix ({ pkgs, lib, ... }:

let
  releases = import ../../release.nix {
    configuration = {
      # Building documentation makes the test unnecessarily take a longer time:
      documentation.enable = lib.mkForce false;

      # Our tests require `grep` & friends:
      environment.systemPackages = with pkgs; [busybox];
    };
  };

  vm-image-metadata = releases.lxdVirtualMachineImageMeta.${pkgs.stdenv.hostPlatform.system};
  vm-image-disk = releases.lxdVirtualMachineImage.${pkgs.stdenv.hostPlatform.system};

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

      incus.enable = true;
    };
  };

  testScript = ''
    def instance_is_up(_) -> bool:
      status, _ = machine.execute("incus exec ${instance-name} --disable-stdin --force-interactive /run/current-system/sw/bin/true")
      return status == 0

    machine.wait_for_unit("incus.service")

    machine.succeed("incus admin init --minimal")

    with subtest("virtual-machine image can be imported"):
        machine.succeed("incus image import ${vm-image-metadata}/*/*.tar.xz ${vm-image-disk}/nixos.qcow2 --alias nixos")

    with subtest("virtual-machine can be launched and become available"):
        machine.succeed("incus launch nixos ${instance-name} --vm --config limits.memory=512MB --config security.secureboot=false")
        with machine.nested("Waiting for instance to start and be usable"):
          retry(instance_is_up)

    with subtest("lxd-agent is started"):
        machine.succeed("incus exec ${instance-name} systemctl is-active lxd-agent")

    with subtest("lxd-agent has a valid path"):
        machine.succeed("incus exec ${instance-name} -- bash -c 'true'")
  '';
})
