{
  name = "systemd-initrd-simple";

  nodes.machine =
    { pkgs, ... }:
    {
      testing.initrdBackdoor = true;
      boot.initrd.systemd.enable = true;
      virtualisation.fileSystems."/".autoResize = true;
    };

  testScript =
    # python
    ''
      import subprocess

      with subtest("testing initrd backdoor"):
          machine.wait_for_unit("initrd.target")
          machine.succeed("systemctl status initrd-fs.target")
          machine.switch_root()

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
          # /nixos-closure didn't leak into stage-2
          machine.succeed("[ ! -e /nixos-closure ]")

      with subtest("groups work"):
          machine.fail("journalctl -b 0 | grep 'systemd-udevd.*Unknown group.*ignoring'")

      with subtest("growfs works"):
          oldAvail = machine.succeed("df --output=avail / | sed 1d")
          machine.shutdown()

          subprocess.check_call(["qemu-img", "resize", "vm-state-machine/machine.qcow2", "+1G"])

          machine.start()
          machine.switch_root()
          newAvail = machine.succeed("df --output=avail / | sed 1d")

          assert int(oldAvail) < int(newAvail), "File system did not grow"

      with subtest("no warnings from systemd about write permissions"):
          machine.fail("journalctl -b 0 | grep 'is marked world-writable, which is a security risk as it is executed with privileges'")
    '';
}
