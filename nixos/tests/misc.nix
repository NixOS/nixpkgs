# Miscellaneous small tests that don't warrant their own VM run.

{ pkgs, ... }:

{

  machine =
    { config, pkgs, ... }:
    { swapDevices = pkgs.lib.mkOverride 0
        [ { device = "/root/swapfile"; size = 128; } ];
      environment.variables.EDITOR = pkgs.lib.mkOverride 0 "emacs";
      services.nixosManual.enable = pkgs.lib.mkOverride 0 true;
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
    '';

}
