import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "systemd-initrd-simple";

  nodes.machine = { pkgs, ... }: {
    boot.initrd.systemd = {
      enable = true;
      emergencyAccess = true;
    };
    fileSystems = lib.mkVMOverride {
      "/".autoResize = true;
    };
  };

  testScript = ''
    import subprocess

    with subtest("handover to stage-2 systemd works"):
        machine.wait_for_unit("multi-user.target")
        machine.succeed("systemd-analyze | grep -q '(initrd)'")  # direct handover
        machine.succeed("touch /testfile")  # / is writable
        machine.fail("touch /nix/store/testfile")  # /nix/store is not writable
        # Special filesystems are mounted by systemd
        machine.succeed("[ -e /run/booted-system ]") # /run
        machine.succeed("[ -e /sys/class ]") # /sys
        machine.succeed("[ -e /dev/null ]") # /dev
        machine.succeed("[ -e /proc/1 ]") # /proc
        # stage-2-init mounted more special filesystems
        machine.succeed("[ -e /dev/shm ]") # /dev/shm
        machine.succeed("[ -e /dev/pts/ptmx ]") # /dev/pts
        machine.succeed("[ -e /run/keys ]") # /run/keys


    with subtest("growfs works"):
        oldAvail = machine.succeed("df --output=avail / | sed 1d")
        machine.shutdown()

        subprocess.check_call(["qemu-img", "resize", "vm-state-machine/machine.qcow2", "+1G"])

        machine.start()
        newAvail = machine.succeed("df --output=avail / | sed 1d")

        assert int(oldAvail) < int(newAvail), "File system did not grow"
  '';
})
