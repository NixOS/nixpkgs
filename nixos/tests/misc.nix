# Miscellaneous small tests that don't warrant their own VM run.

import ./make-test.nix {
  name = "misc";

  machine =
    { config, lib, pkgs, ... }:
    with lib;
    { swapDevices = mkOverride 0
        [ { device = "/root/swapfile"; size = 128; } ];
      environment.variables.EDITOR = mkOverride 0 "emacs";
      services.nixosManual.enable = mkOverride 0 true;
      systemd.tmpfiles.rules = [ "d /tmp 1777 root root 10d" ];
      fileSystems = mkVMOverride { "/tmp2" =
        { fsType = "tmpfs";
          options = "mode=1777,noauto";
        };
      };
      systemd.automounts = singleton
        { wantedBy = [ "multi-user.target" ];
          where = "/tmp2";
        };
    };

  testScript =
    ''
      subtest "nixos-version", sub {
          $machine->succeed("[ `nixos-version | wc -w` = 2 ]");
      };

      subtest "nixos-rebuild", sub {
          $machine->succeed("nixos-rebuild --help | grep SYNOPSIS");
      };

      # Sanity check for uid/gid assignment.
      subtest "users-groups", sub {
          $machine->succeed("[ `id -u messagebus` = 4 ]");
          $machine->succeed("[ `id -g messagebus` = 4 ]");
          $machine->succeed("[ `getent group users` = 'users:x:100:' ]");
      };

      # Regression test for GMP aborts on QEMU.
      subtest "gmp", sub {
          $machine->succeed("expr 1 + 2");
      };

      # Test that the swap file got created.
      subtest "swapfile", sub {
          $machine->waitForUnit("root-swapfile.swap");
          $machine->succeed("ls -l /root/swapfile | grep 134217728");
      };

      # Test whether kernel.poweroff_cmd is set.
      subtest "poweroff_cmd", sub {
          $machine->succeed("[ -x \"\$(cat /proc/sys/kernel/poweroff_cmd)\" ]")
      };

      # Test whether the blkio controller is properly enabled.
      subtest "blkio-cgroup", sub {
          $machine->succeed("[ -n \"\$(cat /sys/fs/cgroup/blkio/blkio.sectors)\" ]")
      };

      # Test whether we have a reboot record in wtmp.
      subtest "reboot-wtmp", sub {
          $machine->succeed("last | grep reboot >&2");
      };

      # Test whether we can override environment variables.
      subtest "override-env-var", sub {
          $machine->succeed('[ "$EDITOR" = emacs ]');
      };

      # Test whether hostname (and by extension nss_myhostname) works.
      subtest "hostname", sub {
          $machine->succeed('[ "`hostname`" = machine ]');
          #$machine->succeed('[ "`hostname -s`" = machine ]');
      };

      # Test whether systemd-udevd automatically loads modules for our hardware.
      subtest "udev-auto-load", sub {
          $machine->waitForUnit('systemd-udev-settle.service');
          $machine->succeed('lsmod | grep psmouse');
      };

      # Test whether systemd-tmpfiles-clean works.
      subtest "tmpfiles", sub {
          $machine->succeed('touch /tmp/foo');
          $machine->succeed('systemctl start systemd-tmpfiles-clean');
          $machine->succeed('[ -e /tmp/foo ]');
          $machine->succeed('date -s "@$(($(date +%s) + 1000000))"'); # move into the future
          $machine->succeed('systemctl start systemd-tmpfiles-clean');
          $machine->fail('[ -e /tmp/foo ]');
      };

      # Test whether automounting works.
      subtest "automount", sub {
          $machine->fail("grep '/tmp2 tmpfs' /proc/mounts");
          $machine->succeed("touch /tmp2/x");
          $machine->succeed("grep '/tmp2 tmpfs' /proc/mounts");
      };

      subtest "shell-vars", sub {
          $machine->succeed('[ -n "$NIX_PATH" ]');
      };
    '';

}
